/**
 * User Model
 * Manages user authentication and profile data for DeliverGaz application
 */

import { Schema, model, Document, Types, type SchemaDefinition } from 'mongoose';
import bcrypt from 'bcryptjs';

/**
 * Address interface
 */
export interface IAddress {
  _id?: Types.ObjectId;
  street: string;
  city: string;
  state?: string;
  postalCode: string;
  country: string;
  coordinates?: {
    latitude: number;
    longitude: number;
  };
  isDefault: boolean;
  label?: string; // e.g., 'Home', 'Work', 'Other'
}

/**
 * User interface
 */
export interface IUser extends Document {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phoneNumber?: string;
  dateOfBirth?: Date;
  role: 'customer' | 'delivery_agent' | 'admin' | 'super_admin';
  status: 'active' | 'inactive' | 'banned' | 'pending_verification';
  avatar?: string;
  addresses: IAddress[];
  preferences: {
    language: string;
    currency: string;
    notifications: {
      email: boolean;
      push: boolean;
      sms: boolean;
    };
    marketing: boolean;
  };
  verification: {
    isEmailVerified: boolean;
    emailVerificationToken?: string;
    emailVerificationExpires?: Date;
    isPhoneVerified: boolean;
    phoneVerificationToken?: string;
    phoneVerificationExpires?: Date;
  };
  security: {
    passwordResetToken?: string;
    passwordResetExpires?: Date;
    passwordChangedAt?: Date;
    loginAttempts: number;
    lockUntil?: Date;
    twoFactorEnabled: boolean;
    twoFactorSecret?: string;
  };
  profile: {
    bio?: string;
    website?: string;
    socialLinks?: {
      facebook?: string;
      twitter?: string;
      instagram?: string;
    };
  };
  deliveryAgent?: {
    vehicleType: 'bike' | 'motorcycle' | 'car' | 'van';
    licenseNumber: string;
    isAvailable: boolean;
    currentLocation?: {
      latitude: number;
      longitude: number;
      updatedAt: Date;
    };
    rating: number;
    totalDeliveries: number;
    zone: string[];
  };
  lastLoginAt?: Date;
  lastActiveAt: Date;
  createdAt: Date;
  updatedAt: Date;

  // Instance methods
  comparePassword(candidatePassword: string): Promise<boolean>;
  generateVerificationToken(): string;
  generatePasswordResetToken(): string;
  isAccountLocked(): boolean;
  incLoginAttempts(): Promise<IUser>;
  resetLoginAttempts(): Promise<IUser>;
  getFullName(): string;
  getDefaultAddress(): IAddress | null;
  addAddress(address: Omit<IAddress, 'isDefault'>): Promise<IUser>;
  updateAddress(addressId: string, address: Partial<IAddress>): Promise<IUser>;
  removeAddress(addressId: string): Promise<IUser>;
  setDefaultAddress(addressId: string): Promise<IUser>;
  updateLastActive(): Promise<IUser>;
}

/**
 * Address Schema
 */
const addressDefinition: SchemaDefinition<IAddress> = {
  street: {
    type: String,
    required: [true, 'Street address is required'],
    trim: true,
    minlength: [5, 'Street address must be at least 5 characters'],
    maxlength: [200, 'Street address cannot exceed 200 characters']
  },
  city: {
    type: String,
    required: [true, 'City is required'],
    trim: true,
    minlength: [2, 'City must be at least 2 characters'],
    maxlength: [100, 'City cannot exceed 100 characters']
  },
  state: {
    type: String,
    trim: true,
    maxlength: [100, 'State cannot exceed 100 characters']
  },
  postalCode: {
    type: String,
    required: [true, 'Postal code is required'],
    trim: true,
    minlength: [3, 'Postal code must be at least 3 characters'],
    maxlength: [20, 'Postal code cannot exceed 20 characters']
  },
  country: {
    type: String,
    required: [true, 'Country is required'],
    trim: true,
    minlength: [2, 'Country must be at least 2 characters'],
    maxlength: [100, 'Country cannot exceed 100 characters']
  },
  coordinates: {
    latitude: {
      type: Number,
      min: [-90, 'Latitude must be between -90 and 90'],
      max: [90, 'Latitude must be between -90 and 90']
    },
    longitude: {
      type: Number,
      min: [-180, 'Longitude must be between -180 and 180'],
      max: [180, 'Longitude must be between -180 and 180']
    }
  },
  isDefault: {
    type: Boolean,
    default: false
  },
  label: {
    type: String,
    enum: ['Home', 'Work', 'Other'],
    default: 'Other'
  }
};

const AddressSchema = new Schema(addressDefinition, { _id: true });

/**
 * User Schema
 */
const UserSchema = new Schema<IUser>({
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email address']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [8, 'Password must be at least 8 characters'],
    select: false // Don't include password in queries by default
  },
  firstName: {
    type: String,
    required: [true, 'First name is required'],
    trim: true,
    minlength: [2, 'First name must be at least 2 characters'],
    maxlength: [50, 'First name cannot exceed 50 characters']
  },
  lastName: {
    type: String,
    required: [true, 'Last name is required'],
    trim: true,
    minlength: [2, 'Last name must be at least 2 characters'],
    maxlength: [50, 'Last name cannot exceed 50 characters']
  },
  phoneNumber: {
    type: String,
    trim: true,
    sparse: true,
    validate: {
      validator: function(v: string) {
        return !v || /^\+?[1-9]\d{1,14}$/.test(v); // E.164 format
      },
      message: 'Please provide a valid phone number'
    }
  },
  dateOfBirth: {
    type: Date,
    validate: {
      validator: function(v: Date) {
        return !v || v < new Date();
      },
      message: 'Date of birth must be in the past'
    }
  },
  role: {
    type: String,
    enum: ['customer', 'delivery_agent', 'admin', 'super_admin'],
    default: 'customer',
    index: true
  },
  status: {
    type: String,
    enum: ['active', 'inactive', 'banned', 'pending_verification'],
    default: 'pending_verification',
    index: true
  },
  avatar: {
    type: String,
    validate: {
      validator: function(v: string) {
        return !v || /^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$/i.test(v);
      },
      message: 'Avatar must be a valid image URL'
    }
  },
  addresses: {
    type: [AddressSchema],
    default: [],
    validate: {
      validator: function(addresses: IAddress[]) {
        const defaultAddresses = addresses.filter(addr => addr.isDefault);
        return defaultAddresses.length <= 1;
      },
      message: 'Only one address can be set as default'
    }
  },
  preferences: {
    language: {
      type: String,
      enum: ['en', 'fr', 'es', 'de'],
      default: 'en'
    },
    currency: {
      type: String,
      enum: ['USD', 'EUR', 'GBP', 'XAF', 'XOF'],
      default: 'USD'
    },
    notifications: {
      email: { type: Boolean, default: true },
      push: { type: Boolean, default: true },
      sms: { type: Boolean, default: false }
    },
    marketing: { type: Boolean, default: false }
  },
  verification: {
    isEmailVerified: { type: Boolean, default: false },
    emailVerificationToken: String,
    emailVerificationExpires: Date,
    isPhoneVerified: { type: Boolean, default: false },
    phoneVerificationToken: String,
    phoneVerificationExpires: Date
  },
  security: {
    passwordResetToken: String,
    passwordResetExpires: Date,
    passwordChangedAt: Date,
    loginAttempts: { type: Number, default: 0 },
    lockUntil: Date,
    twoFactorEnabled: { type: Boolean, default: false },
    twoFactorSecret: String
  },
  profile: {
    bio: {
      type: String,
      maxlength: [500, 'Bio cannot exceed 500 characters']
    },
    website: {
      type: String,
      validate: {
        validator: function(v: string) {
          return !v || /^https?:\/\/.+\..+/.test(v);
        },
        message: 'Website must be a valid URL'
      }
    },
    socialLinks: {
      facebook: String,
      twitter: String,
      instagram: String
    }
  },
  deliveryAgent: {
    vehicleType: {
      type: String,
      enum: ['bike', 'motorcycle', 'car', 'van']
    },
    licenseNumber: String,
    isAvailable: { type: Boolean, default: false },
    currentLocation: {
      latitude: Number,
      longitude: Number,
      updatedAt: { type: Date, default: Date.now }
    },
    rating: { type: Number, default: 0, min: 0, max: 5 },
    totalDeliveries: { type: Number, default: 0 },
    zone: [String]
  },
  lastLoginAt: Date,
  lastActiveAt: { type: Date, default: Date.now }
} as any, {
  timestamps: true,
  toJSON: { 
    virtuals: true,
    transform: function(doc, ret) {
      delete (ret as any).password;
      if (ret.security) {
        delete (ret.security as any).twoFactorSecret;
        delete (ret.security as any).passwordResetToken;
      }
      if (ret.verification) {
        delete (ret.verification as any).emailVerificationToken;
        delete ret.verification.phoneVerificationToken;
      }
      return ret;
    }
  },
  toObject: { virtuals: true }
});

/**
 * Indexes for better performance
 */
UserSchema.index({ role: 1, status: 1 });
UserSchema.index({ 'verification.isEmailVerified': 1 });
UserSchema.index({ lastActiveAt: 1 });
UserSchema.index({ 'deliveryAgent.isAvailable': 1, 'deliveryAgent.zone': 1 });

/**
 * Virtual for full name
 */
UserSchema.virtual('fullName').get(function(this: IUser) {
  return `${this.firstName} ${this.lastName}`;
});

/**
 * Virtual for account lock status
 */
UserSchema.virtual('isLocked').get(function(this: IUser) {
  return !!(this.security.lockUntil && this.security.lockUntil > new Date());
});

/**
 * Pre-save middleware
 */
UserSchema.pre('save', async function(this: IUser, next) {
  // Hash password if modified
  if (this.isModified('password')) {
    const salt = await bcrypt.genSalt(12);
    this.password = await bcrypt.hash(this.password, salt);
    this.security.passwordChangedAt = new Date();
  }

  // Update lastActiveAt
  if (this.isModified('lastLoginAt')) {
    this.lastActiveAt = new Date();
  }

  // Ensure only one default address
  if (this.isModified('addresses')) {
    const defaultAddresses = this.addresses.filter(addr => addr.isDefault);
    if (defaultAddresses.length > 1) {
      // Keep only the first default address
      this.addresses.forEach((addr, index) => {
        if (index > 0 && addr.isDefault) {
          addr.isDefault = false;
        }
      });
    }
  }

  next();
});

/**
 * Instance Methods
 */

/**
 * Compare password
 */
UserSchema.methods.comparePassword = async function(
  this: IUser,
  candidatePassword: string
): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

/**
 * Generate email verification token
 */
UserSchema.methods.generateVerificationToken = function(this: IUser): string {
  const token = Math.random().toString(36).substring(2, 15) + 
                Math.random().toString(36).substring(2, 15);
  
  this.verification.emailVerificationToken = token;
  this.verification.emailVerificationExpires = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
  
  return token;
};

/**
 * Generate password reset token
 */
UserSchema.methods.generatePasswordResetToken = function(this: IUser): string {
  const token = Math.random().toString(36).substring(2, 15) + 
                Math.random().toString(36).substring(2, 15);
  
  this.security.passwordResetToken = token;
  this.security.passwordResetExpires = new Date(Date.now() + 60 * 60 * 1000); // 1 hour
  
  return token;
};

/**
 * Check if account is locked
 */
UserSchema.methods.isAccountLocked = function(this: IUser): boolean {
  return !!(this.security.lockUntil && this.security.lockUntil > new Date());
};

/**
 * Increment login attempts
 */
UserSchema.methods.incLoginAttempts = async function(this: IUser): Promise<IUser> {
  // If we have a previous lock and it has expired, restart at 1
  if (this.security.lockUntil && this.security.lockUntil < new Date()) {
    return this.updateOne({
      $unset: { 'security.lockUntil': 1 },
      $set: { 'security.loginAttempts': 1 }
    }).exec();
  }

  const updates: any = { $inc: { 'security.loginAttempts': 1 } };
  
  // If we have max attempts and there is no lock, lock the account
  if (this.security.loginAttempts + 1 >= 5 && !this.isAccountLocked()) {
    updates.$set = { 'security.lockUntil': new Date(Date.now() + 2 * 60 * 60 * 1000) }; // 2 hours
  }
  
  return this.updateOne(updates).exec();
};

/**
 * Reset login attempts
 */
UserSchema.methods.resetLoginAttempts = async function(this: IUser): Promise<IUser> {
  return this.updateOne({
    $unset: {
      'security.loginAttempts': 1,
      'security.lockUntil': 1
    }
  }).exec();
};

/**
 * Get full name
 */
UserSchema.methods.getFullName = function(this: IUser): string {
  return `${this.firstName} ${this.lastName}`;
};

/**
 * Get default address
 */
UserSchema.methods.getDefaultAddress = function(this: IUser): IAddress | null {
  const defaultAddress = this.addresses.find(addr => addr.isDefault);
  return defaultAddress || (this.addresses.length > 0 ? this.addresses[0] : null);
};

/**
 * Add address
 */
UserSchema.methods.addAddress = async function(
  this: IUser,
  address: Omit<IAddress, 'isDefault'>
): Promise<IUser> {
  const newAddress = { ...address, isDefault: this.addresses.length === 0 };
  this.addresses.push(newAddress as IAddress);
  return this.save();
};

/**
 * Update address
 */
UserSchema.methods.updateAddress = async function(
  this: IUser,
  addressId: string,
  updates: Partial<IAddress>
): Promise<IUser> {
  const address = this.addresses.find(addr => addr._id?.toString() === addressId);
  if (!address) {
    throw new Error('Address not found');
  }

  Object.assign(address, updates);
  return this.save();
};

/**
 * Remove address
 */
UserSchema.methods.removeAddress = async function(
  this: IUser,
  addressId: string
): Promise<IUser> {
  const addressIndex = this.addresses.findIndex(addr => addr._id?.toString() === addressId);
  if (addressIndex === -1) {
    throw new Error('Address not found');
  }

  const wasDefault = this.addresses[addressIndex].isDefault;
  this.addresses.splice(addressIndex, 1);

  // If removed address was default, make first address default
  if (wasDefault && this.addresses.length > 0) {
    this.addresses[0].isDefault = true;
  }

  return this.save();
};

/**
 * Set default address
 */
UserSchema.methods.setDefaultAddress = async function(
  this: IUser,
  addressId: string
): Promise<IUser> {
  // Remove default from all addresses
  this.addresses.forEach(addr => {
    addr.isDefault = false;
  });

  // Set new default
  const address = this.addresses.find(addr => addr._id?.toString() === addressId);
  if (!address) {
    throw new Error('Address not found');
  }

  address.isDefault = true;
  return this.save();
};

/**
 * Update last active timestamp
 */
UserSchema.methods.updateLastActive = async function(this: IUser): Promise<IUser> {
  this.lastActiveAt = new Date();
  return this.save();
};

/**
 * Static Methods
 */

/**
 * Find user by email (including password for authentication)
 */
UserSchema.statics.findByEmailWithPassword = function(email: string) {
  return this.findOne({ email }).select('+password');
};

/**
 * Find active users
 */
UserSchema.statics.findActiveUsers = function() {
  return this.find({ status: 'active' });
};

/**
 * Find delivery agents in zone
 */
UserSchema.statics.findAvailableDeliveryAgents = function(zone: string) {
  return this.find({
    role: 'delivery_agent',
    status: 'active',
    'deliveryAgent.isAvailable': true,
    'deliveryAgent.zone': zone
  });
};

/**
 * Clean up unverified accounts
 */
UserSchema.statics.cleanupUnverifiedAccounts = function() {
  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
  return this.deleteMany({
    status: 'pending_verification',
    createdAt: { $lt: thirtyDaysAgo }
  });
};

/**
 * Export the model
 */
export const User = model<IUser>('User', UserSchema);
export default User;