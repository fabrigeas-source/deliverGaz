/**
 * Cart Model Usage Examples
 * Demonstrates how to use the Cart model in real-world scenarios
 */

import { Types } from 'mongoose';
import Cart, { ICart, ICartItem } from './cart.model';

/**
 * Example 1: Creating a new cart for a logged-in user
 */
export const createUserCart = async (userId: string): Promise<ICart> => {
  try {
    const cart = new Cart({
      userId: new Types.ObjectId(userId),
      status: 'active',
      currency: 'USD'
    });

    await cart.save();
    console.log('User cart created:', cart._id);
    return cart;
  } catch (error) {
    console.error('Error creating user cart:', error);
    throw error;
  }
};

/**
 * Example 2: Creating a cart for a guest user
 */
export const createGuestCart = async (sessionId: string): Promise<ICart> => {
  try {
    const cart = new Cart({
      sessionId,
      status: 'active',
      currency: 'USD'
    });

    await cart.save();
    console.log('Guest cart created:', cart._id);
    return cart;
  } catch (error) {
    console.error('Error creating guest cart:', error);
    throw error;
  }
};

/**
 * Example 3: Adding items to cart
 */
export const addItemsToCart = async (cartId: string): Promise<ICart> => {
  try {
    const cart = await Cart.findById(cartId);
    if (!cart) {
      throw new Error('Cart not found');
    }

    // Add first item
    await cart.addItem(
      '507f1f77bcf86cd799439011', // Product ID
      2,                          // Quantity
      29.99,                      // Price
      { size: 'large', color: 'red' } // Options
    );

    // Add second item
    await cart.addItem(
      '507f1f77bcf86cd799439012',
      1,
      15.50,
      { flavor: 'vanilla' }
    );

    // Add third item (same product, different options)
    await cart.addItem(
      '507f1f77bcf86cd799439011',
      1,
      29.99,
      { size: 'medium', color: 'blue' }
    );

    console.log('Items added to cart:', {
      totalItems: cart.totalItems,
      totalAmount: cart.totalAmount,
      itemCount: cart.items.length
    });

    return cart;
  } catch (error) {
    console.error('Error adding items to cart:', error);
    throw error;
  }
};

/**
 * Example 4: Updating item quantities
 */
export const updateCartItems = async (cartId: string): Promise<ICart> => {
  try {
    const cart = await Cart.findById(cartId);
    if (!cart) {
      throw new Error('Cart not found');
    }

    // Update quantity of first item
    await cart.updateItem('507f1f77bcf86cd799439011', 5);

    // Remove an item by setting quantity to 0
    await cart.updateItem('507f1f77bcf86cd799439012', 0);

    console.log('Cart updated:', {
      totalItems: cart.totalItems,
      totalAmount: cart.totalAmount
    });

    return cart;
  } catch (error) {
    console.error('Error updating cart items:', error);
    throw error;
  }
};

/**
 * Example 5: Removing specific items
 */
export const removeItemFromCart = async (cartId: string, productId: string): Promise<ICart> => {
  try {
    const cart = await Cart.findById(cartId);
    if (!cart) {
      throw new Error('Cart not found');
    }

    await cart.removeItem(productId);

    console.log('Item removed from cart:', {
      remainingItems: cart.items.length,
      totalAmount: cart.totalAmount
    });

    return cart;
  } catch (error) {
    console.error('Error removing item from cart:', error);
    throw error;
  }
};

/**
 * Example 6: Finding active cart for user
 */
export const findUserActiveCart = async (userId: string): Promise<ICart | null> => {
  try {
    const cart = await Cart.findActiveCart(userId);
    
    if (cart) {
      console.log('Found active cart:', {
        cartId: cart._id,
        itemCount: cart.items.length,
        totalAmount: cart.totalAmount
      });
    } else {
      console.log('No active cart found for user');
    }

    return cart;
  } catch (error) {
    console.error('Error finding user cart:', error);
    throw error;
  }
};

/**
 * Example 7: Creating or getting cart (handles both cases)
 */
export const getOrCreateCart = async (userId?: string, sessionId?: string): Promise<ICart> => {
  try {
    const cart = await Cart.createOrGetCart(userId, sessionId);
    
    console.log('Cart ready:', {
      cartId: cart._id,
      isNew: cart.items.length === 0,
      userId: cart.userId,
      sessionId: cart.sessionId
    });

    return cart;
  } catch (error) {
    console.error('Error getting/creating cart:', error);
    throw error;
  }
};

/**
 * Example 8: Merging guest cart with user cart on login
 */
export const mergeCartsOnLogin = async (guestSessionId: string, userId: string): Promise<ICart | null> => {
  try {
    const mergedCart = await Cart.mergeGuestCart(guestSessionId, userId);
    
    if (mergedCart) {
      console.log('Carts merged successfully:', {
        cartId: mergedCart._id,
        totalItems: mergedCart.totalItems,
        totalAmount: mergedCart.totalAmount
      });
    } else {
      console.log('No guest cart to merge');
    }

    return mergedCart;
  } catch (error) {
    console.error('Error merging carts:', error);
    throw error;
  }
};

/**
 * Example 9: Working with cart summary
 */
export const displayCartSummary = async (cartId: string): Promise<void> => {
  try {
    const cart = await Cart.findById(cartId);
    if (!cart) {
      throw new Error('Cart not found');
    }

    const summary = cart.summary;
    
    console.log('Cart Summary:', {
      cartId: cart._id,
      summary,
      items: cart.items.map(item => ({
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        subtotal: item.quantity * item.price,
        options: item.selectedOptions
      }))
    });

  } catch (error) {
    console.error('Error displaying cart summary:', error);
    throw error;
  }
};

/**
 * Example 10: Checking cart expiration
 */
export const checkCartExpiration = async (cartId: string): Promise<boolean> => {
  try {
    const cart = await Cart.findById(cartId);
    if (!cart) {
      throw new Error('Cart not found');
    }

    const isExpired = cart.isExpired();
    
    console.log('Cart expiration check:', {
      cartId: cart._id,
      expiresAt: cart.expiresAt,
      isExpired,
      timeRemaining: cart.expiresAt ? 
        Math.max(0, cart.expiresAt.getTime() - Date.now()) : 0
    });

    return isExpired;
  } catch (error) {
    console.error('Error checking cart expiration:', error);
    throw error;
  }
};

/**
 * Example 11: Clearing cart contents
 */
export const clearCart = async (cartId: string): Promise<ICart> => {
  try {
    const cart = await Cart.findById(cartId);
    if (!cart) {
      throw new Error('Cart not found');
    }

    await cart.clearCart();

    console.log('Cart cleared:', {
      cartId: cart._id,
      status: cart.status,
      itemCount: cart.items.length
    });

    return cart;
  } catch (error) {
    console.error('Error clearing cart:', error);
    throw error;
  }
};

/**
 * Example 12: Bulk cart operations
 */
export const bulkCartOperations = async (userId: string): Promise<void> => {
  try {
    // Get or create cart
    const cart = await Cart.createOrGetCart(userId);

    // Add multiple items
    const products = [
      { id: '507f1f77bcf86cd799439011', quantity: 2, price: 29.99, options: { size: 'L' } },
      { id: '507f1f77bcf86cd799439012', quantity: 1, price: 45.00, options: { color: 'red' } },
      { id: '507f1f77bcf86cd799439013', quantity: 3, price: 12.50, options: {} }
    ];

    for (const product of products) {
      await cart.addItem(product.id, product.quantity, product.price, product.options);
    }

    console.log('Bulk operations completed:', cart.summary);

  } catch (error) {
    console.error('Error in bulk operations:', error);
    throw error;
  }
};

/**
 * Example 13: Cart maintenance and cleanup
 */
export const performCartMaintenance = async (): Promise<void> => {
  try {
    // Clean up expired carts
    const deleteResult = await Cart.cleanupExpiredCarts();
    
    console.log('Cart maintenance completed:', {
      deletedCount: deleteResult.deletedCount,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error during cart maintenance:', error);
    throw error;
  }
};

/**
 * Example 14: Advanced cart queries
 */
export const advancedCartQueries = async (): Promise<void> => {
  try {
    // Find all active carts with items
    const activeCarts = await Cart.find({
      status: 'active',
      'items.0': { $exists: true } // Has at least one item
    }).populate('items.productId');

    // Find carts expiring soon (next 24 hours)
    const expiringSoon = await Cart.find({
      expiresAt: {
        $gte: new Date(),
        $lte: new Date(Date.now() + 24 * 60 * 60 * 1000)
      },
      status: 'active'
    });

    // Find high-value carts
    const highValueCarts = await Cart.find({
      totalAmount: { $gte: 100 },
      status: 'active'
    }).sort({ totalAmount: -1 });

    console.log('Advanced queries results:', {
      activeCartsWithItems: activeCarts.length,
      expiringSoon: expiringSoon.length,
      highValueCarts: highValueCarts.length
    });

  } catch (error) {
    console.error('Error in advanced queries:', error);
    throw error;
  }
};

/**
 * Example 15: Cart validation and error handling
 */
export const cartValidationExample = async (userId: string): Promise<void> => {
  try {
    const cart = await Cart.createOrGetCart(userId);

    // Test quantity limits
    try {
      await cart.addItem('507f1f77bcf86cd799439011', 101, 29.99); // Should fail
    } catch (error) {
      console.log('Quantity validation works:', (error as Error).message);
    }

    // Test negative price
    try {
      await cart.addItem('507f1f77bcf86cd799439011', 1, -10); // Should fail
    } catch (error) {
      console.log('Price validation works:', (error as Error).message);
    }

    // Test maximum items limit
    const maxItems = 51;
    try {
      for (let i = 0; i < maxItems; i++) {
        await cart.addItem(
          new Types.ObjectId().toString(),
          1,
          10,
          { index: i }
        );
      }
    } catch (error) {
      console.log('Max items validation works:', (error as Error).message);
    }

  } catch (error) {
    console.error('Error in validation example:', error);
    throw error;
  }
};

/**
 * Example 16: Real-world shopping cart workflow
 */
export const shoppingCartWorkflow = async (userId: string): Promise<void> => {
  try {
    console.log('Starting shopping cart workflow...');

    // Step 1: Get or create cart
    const cart = await getOrCreateCart(userId);

    // Step 2: Add products to cart
    await cart.addItem('507f1f77bcf86cd799439011', 2, 29.99, { size: 'Large' });
    await cart.addItem('507f1f77bcf86cd799439012', 1, 49.99, { color: 'Blue' });
    
    console.log('Step 2 - Items added:', cart.summary);

    // Step 3: Update quantities
    await cart.updateItem('507f1f77bcf86cd799439011', 3);
    console.log('Step 3 - Quantity updated:', cart.summary);

    // Step 4: Add more items
    await cart.addItem('507f1f77bcf86cd799439013', 1, 19.99);
    console.log('Step 4 - More items added:', cart.summary);

    // Step 5: Remove an item
    await cart.removeItem('507f1f77bcf86cd799439012');
    console.log('Step 5 - Item removed:', cart.summary);

    // Step 6: Display final cart
    await displayCartSummary(cart._id?.toString() || '');

    console.log('Shopping cart workflow completed successfully!');

  } catch (error) {
    console.error('Error in shopping cart workflow:', error);
    throw error;
  }
};

// Export all examples
export default {
  createUserCart,
  createGuestCart,
  addItemsToCart,
  updateCartItems,
  removeItemFromCart,
  findUserActiveCart,
  getOrCreateCart,
  mergeCartsOnLogin,
  displayCartSummary,
  checkCartExpiration,
  clearCart,
  bulkCartOperations,
  performCartMaintenance,
  advancedCartQueries,
  cartValidationExample,
  shoppingCartWorkflow
};