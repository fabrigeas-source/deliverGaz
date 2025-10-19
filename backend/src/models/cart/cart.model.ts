/**
 * Cart Model
 * Manages shopping cart functionality for DeliverGaz application
 */

import { Schema, model, Document, Types, Model } from 'mongoose';

/**
 * Cart Item interface
 */
export interface ICartItem {
  productId: Types.ObjectId;
  quantity: number;
  price: number;
  selectedOptions?: {
    size?: string;
    color?: string;
    flavor?: string;
    [key: string]: any;
  };
  addedAt: Date;
  updatedAt: Date;
}

/**
 * Cart interface
 */
export interface ICart extends Document {
  userId: Types.ObjectId;
  items: ICartItem[];
  totalItems: number;
  totalAmount: number;
  currency: string;
  discount?: number;
  sessionId?: string; // For guest users
  status: 'active' | 'abandoned' | 'converted';
  expiresAt?: Date;
  createdAt: Date;
  updatedAt: Date;
  
  // Instance methods
  addItem(productId: string, quantity: number, price: number, options?: any): Promise<ICart>;
  updateItem(productId: string, quantity: number): Promise<ICart>;
  removeItem(productId: string): Promise<ICart>;
  clearCart(): Promise<ICart>;
  calculateTotals(): Promise<ICart>;
  calculateTotalsSync(): void;
  isExpired(): boolean;
  // Virtual properties
  summary: {
    itemCount: number;
    subtotal: number;
    tax: number;
    discount: number;
    total: number;
    hasItems: boolean;
  };
}

/**
 * Cart Model interface (includes static methods)
 */
export interface ICartModel extends Model<ICart> {
  findActiveCart(userId?: string, sessionId?: string): Promise<ICart | null>;
  createOrGetCart(userId?: string, sessionId?: string): Promise<ICart>;
  mergeGuestCart(guestSessionId: string, userId: string): Promise<ICart>;
  cleanupExpiredCarts(): Promise<{ deletedCount: number }>;
}

/**
 * Cart Item Schema
 */
const CartItemSchema = new Schema<ICartItem>({
  productId: {
    type: Schema.Types.ObjectId,
    ref: 'Product',
    required: [true, 'Product ID is required'],
    index: true
  },
  quantity: {
    type: Number,
    required: [true, 'Quantity is required'],
    min: [1, 'Quantity must be at least 1'],
    max: [100, 'Quantity cannot exceed 100']
  },
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: [0, 'Price must be positive'],
    set: (value: number) => Math.round(value * 100) / 100 // Round to 2 decimal places
  },
  selectedOptions: {
    type: Schema.Types.Mixed,
    default: {}
  },
  addedAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  _id: false // Don't create separate _id for subdocuments
});

/**
 * Cart Schema
 */
const CartSchema = new Schema<ICart>({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: function(this: ICart) {
      return !this.sessionId; // Required if sessionId is not provided
    },
    index: true
  },
  items: {
    type: [CartItemSchema],
    default: [],
    validate: {
      validator: function(items: ICartItem[]) {
        return items.length <= 50; // Maximum 50 items per cart
      },
      message: 'Cart cannot contain more than 50 items'
    }
  },
  totalItems: {
    type: Number,
    default: 0,
    min: [0, 'Total items cannot be negative']
  },
  totalAmount: {
    type: Number,
    default: 0,
    min: [0, 'Total amount cannot be negative'],
    set: (value: number) => Math.round(value * 100) / 100
  },
  currency: {
    type: String,
    default: 'USD',
    enum: ['USD', 'EUR', 'GBP', 'XAF', 'XOF'], // Add supported currencies
    uppercase: true
  },
  discount: {
    type: Number,
    default: 0,
    min: [0, 'Discount cannot be negative']
  },
  sessionId: {
    type: String,
    index: true,
    sparse: true, // Allow multiple null values
    required: function(this: ICart) {
      return !this.userId; // Required if userId is not provided
    }
  },
  status: {
    type: String,
    enum: ['active', 'abandoned', 'converted'],
    default: 'active',
    index: true
  },
  expiresAt: {
    type: Date,
    default: function() {
      // Cart expires after 30 days for logged-in users, 7 days for guests
      const days = this.userId ? 30 : 7;
      return new Date(Date.now() + days * 24 * 60 * 60 * 1000);
    },
    index: { expireAfterSeconds: 0 } // MongoDB TTL index
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

/**
 * Indexes for better performance
 */
CartSchema.index({ userId: 1, status: 1 });
CartSchema.index({ sessionId: 1, status: 1 });
CartSchema.index({ updatedAt: 1 });

/**
 * Virtual for cart summary
 */
CartSchema.virtual('summary').get(function(this: ICart) {
  return {
    totalItems: this.totalItems,
    totalAmount: this.totalAmount,
    currency: this.currency,
    itemCount: this.items.length,
    status: this.status
  };
});

/**
 * Pre-save middleware to update totals
 */
CartSchema.pre('save', function(this: ICart, next) {
  this.calculateTotalsSync();
  next();
});

/**
 * Instance Methods
 */

/**
 * Add item to cart
 */
CartSchema.methods.addItem = async function(
  this: ICart,
  productId: string,
  quantity: number,
  price: number,
  options: any = {}
): Promise<ICart> {
  const existingItemIndex = this.items.findIndex(
    item => item.productId.toString() === productId &&
    JSON.stringify(item.selectedOptions) === JSON.stringify(options)
  );

  if (existingItemIndex >= 0) {
    // Update existing item
    this.items[existingItemIndex].quantity += quantity;
    this.items[existingItemIndex].updatedAt = new Date();
  } else {
    // Add new item
    this.items.push({
      productId: new Types.ObjectId(productId),
      quantity,
      price,
      selectedOptions: options,
      addedAt: new Date(),
      updatedAt: new Date()
    });
  }

  return this.save();
};

/**
 * Update item quantity
 */
CartSchema.methods.updateItem = async function(
  this: ICart,
  productId: string,
  quantity: number
): Promise<ICart> {
  const itemIndex = this.items.findIndex(
    item => item.productId.toString() === productId
  );

  if (itemIndex === -1) {
    throw new Error('Item not found in cart');
  }

  if (quantity <= 0) {
    return this.removeItem(productId);
  }

  this.items[itemIndex].quantity = quantity;
  this.items[itemIndex].updatedAt = new Date();

  return this.save();
};

/**
 * Remove item from cart
 */
CartSchema.methods.removeItem = async function(
  this: ICart,
  productId: string
): Promise<ICart> {
  this.items = this.items.filter(
    item => item.productId.toString() !== productId
  );

  return this.save();
};

/**
 * Clear all items from cart
 */
CartSchema.methods.clearCart = async function(this: ICart): Promise<ICart> {
  this.items = [];
  this.status = 'abandoned';
  return this.save();
};

/**
 * Calculate totals (async version)
 */
CartSchema.methods.calculateTotals = async function(this: ICart): Promise<ICart> {
  this.calculateTotalsSync();
  return this.save();
};

/**
 * Calculate totals (sync version for pre-save)
 */
CartSchema.methods.calculateTotalsSync = function(this: ICart): void {
  this.totalItems = this.items.reduce((total, item) => total + item.quantity, 0);
  this.totalAmount = this.items.reduce(
    (total, item) => total + (item.price * item.quantity),
    0
  );
  // Round to 2 decimal places
  this.totalAmount = Math.round(this.totalAmount * 100) / 100;
};

/**
 * Check if cart is expired
 */
CartSchema.methods.isExpired = function(this: ICart): boolean {
  return this.expiresAt ? this.expiresAt < new Date() : false;
};

/**
 * Virtual: Summary of cart
 */
CartSchema.virtual('summary').get(function(this: ICart) {
  const subtotal = this.totalAmount || 0;
  const tax = subtotal * 0.1; // 10% tax
  const discount = this.discount || 0;
  const total = subtotal + tax - discount;
  
  return {
    itemCount: this.totalItems || 0,
    subtotal: Math.round(subtotal * 100) / 100,
    tax: Math.round(tax * 100) / 100,
    discount,
    total: Math.round(total * 100) / 100,
    hasItems: (this.totalItems || 0) > 0
  };
});

/**
 * Static Methods
 */

/**
 * Find active cart by user or session
 */
CartSchema.statics.findActiveCart = function(
  userId?: string,
  sessionId?: string
) {
  const query: any = { status: 'active' };
  
  if (userId) {
    query.userId = userId;
  } else if (sessionId) {
    query.sessionId = sessionId;
  } else {
    throw new Error('Either userId or sessionId must be provided');
  }

  return this.findOne(query).populate('items.productId');
};

/**
 * Create or get cart
 */
CartSchema.statics.createOrGetCart = async function(
  userId?: string,
  sessionId?: string
) {
  let cart = await (this as ICartModel).findActiveCart(userId, sessionId);
  
  if (!cart) {
    cart = new this({
      userId: userId ? new Types.ObjectId(userId) : undefined,
      sessionId,
      status: 'active'
    });
    await cart.save();
  }

  return cart;
};

/**
 * Merge guest cart with user cart
 */
CartSchema.statics.mergeGuestCart = async function(
  guestSessionId: string,
  userId: string
) {
  const guestCart = await this.findOne({ 
    sessionId: guestSessionId, 
    status: 'active' 
  });
  
  if (!guestCart || guestCart.items.length === 0) {
    return null;
  }

  let userCart = await this.findOne({ 
    userId: new Types.ObjectId(userId), 
    status: 'active' 
  });

  if (!userCart) {
    // Convert guest cart to user cart
    guestCart.userId = new Types.ObjectId(userId);
    guestCart.sessionId = undefined;
    return guestCart.save();
  }

  // Merge items from guest cart to user cart
  for (const guestItem of guestCart.items) {
    await userCart.addItem(
      guestItem.productId.toString(),
      guestItem.quantity,
      guestItem.price,
      guestItem.selectedOptions
    );
  }

  // Mark guest cart as converted
  guestCart.status = 'converted';
  await guestCart.save();

  return userCart;
};

/**
 * Clean up expired carts
 */
CartSchema.statics.cleanupExpiredCarts = function() {
  return this.deleteMany({
    $or: [
      { expiresAt: { $lt: new Date() } },
      { status: 'abandoned', updatedAt: { $lt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) } }
    ]
  });
};

/**
 * Export the model
 */
export const Cart = model<ICart, ICartModel>('Cart', CartSchema);
export default Cart;