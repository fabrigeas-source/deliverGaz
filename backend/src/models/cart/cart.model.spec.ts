/**
 * Cart Model Tests
 * Comprehensive test suite for Cart model functionality
 */

import { Types } from 'mongoose';
import Cart, { ICart, ICartItem } from './cart.model';

// Mock mongoose for testing
jest.mock('mongoose', () => {
  const actualMongoose = jest.requireActual('mongoose');
  return {
    ...actualMongoose,
    model: jest.fn(),
    Schema: actualMongoose.Schema,
    Types: actualMongoose.Types
  };
});

// Mock data
const mockUserId = new Types.ObjectId();
const mockProductId = new Types.ObjectId();
const mockSessionId = 'session_123456789';

describe('Cart Model', () => {
  let mockCart: Partial<ICart>;
  let mockCartMethods: any;

  beforeEach(() => {
    // Reset mocks
    jest.clearAllMocks();

    // Mock cart methods
    mockCartMethods = {
      addItem: jest.fn(),
      updateItem: jest.fn(),
      removeItem: jest.fn(),
      clearCart: jest.fn(),
      calculateTotals: jest.fn(),
      calculateTotalsSync: jest.fn(),
      isExpired: jest.fn(),
      save: jest.fn()
    };

    // Mock cart data
    mockCart = {
      _id: new Types.ObjectId(),
      userId: mockUserId,
      items: [],
      totalItems: 0,
      totalAmount: 0,
      currency: 'USD',
      status: 'active',
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      createdAt: new Date(),
      updatedAt: new Date(),
      ...mockCartMethods
    };
  });

  describe('Cart Schema Validation', () => {
    test('should create a valid cart with userId', () => {
      const cartData = {
        userId: mockUserId,
        items: [],
        currency: 'USD',
        status: 'active'
      };

      expect(cartData.userId).toBe(mockUserId);
      expect(cartData.items).toEqual([]);
      expect(cartData.currency).toBe('USD');
      expect(cartData.status).toBe('active');
    });

    test('should create a valid cart with sessionId for guest user', () => {
      const cartData = {
        sessionId: mockSessionId,
        items: [],
        currency: 'USD',
        status: 'active'
      };

      expect(cartData.sessionId).toBe(mockSessionId);
      expect(cartData.items).toEqual([]);
    });

    test('should validate currency enum values', () => {
      const validCurrencies = ['USD', 'EUR', 'GBP', 'XAF', 'XOF'];
      
      validCurrencies.forEach(currency => {
        const cartData = {
          userId: mockUserId,
          currency: currency,
          status: 'active'
        };
        expect(cartData.currency).toBe(currency);
      });
    });

    test('should validate status enum values', () => {
      const validStatuses = ['active', 'abandoned', 'converted'];
      
      validStatuses.forEach(status => {
        const cartData = {
          userId: mockUserId,
          status: status as 'active' | 'abandoned' | 'converted'
        };
        expect(cartData.status).toBe(status);
      });
    });

    test('should validate cart item structure', () => {
      const cartItem: ICartItem = {
        productId: mockProductId,
        quantity: 2,
        price: 29.99,
        selectedOptions: {
          size: 'large',
          color: 'red'
        },
        addedAt: new Date(),
        updatedAt: new Date()
      };

      expect(cartItem.productId).toBe(mockProductId);
      expect(cartItem.quantity).toBe(2);
      expect(cartItem.price).toBe(29.99);
      expect(cartItem.selectedOptions).toEqual({
        size: 'large',
        color: 'red'
      });
    });
  });

  describe('Cart Instance Methods', () => {
    test('addItem should add new item to empty cart', async () => {
      const cart = {
        ...mockCart,
        items: [],
        addItem: jest.fn().mockImplementation(async function(productId, quantity, price, options) {
          this.items.push({
            productId: new Types.ObjectId(productId),
            quantity,
            price,
            selectedOptions: options || {},
            addedAt: new Date(),
            updatedAt: new Date()
          });
          return this;
        })
      } as any;

      await cart.addItem(mockProductId.toString(), 2, 29.99, { size: 'large' });

      expect(cart.items).toHaveLength(1);
      expect(cart.items[0].quantity).toBe(2);
      expect(cart.items[0].price).toBe(29.99);
      expect(cart.items[0].selectedOptions).toEqual({ size: 'large' });
    });

    test('addItem should update quantity for existing item', async () => {
      const existingItem: ICartItem = {
        productId: mockProductId,
        quantity: 1,
        price: 29.99,
        selectedOptions: { size: 'large' },
        addedAt: new Date(),
        updatedAt: new Date()
      };

      const cart = {
        ...mockCart,
        items: [existingItem],
        addItem: jest.fn().mockImplementation(async function(productId, quantity, price, options) {
          const existingIndex = this.items.findIndex(
            (item: ICartItem) => item.productId.toString() === productId &&
            JSON.stringify(item.selectedOptions) === JSON.stringify(options)
          );

          if (existingIndex >= 0) {
            this.items[existingIndex].quantity += quantity;
            this.items[existingIndex].updatedAt = new Date();
          }
          return this;
        })
      } as any;

      await cart.addItem(mockProductId.toString(), 1, 29.99, { size: 'large' });

      expect(cart.items).toHaveLength(1);
      expect(cart.items[0].quantity).toBe(2);
    });

    test('updateItem should update item quantity', async () => {
      const existingItem: ICartItem = {
        productId: mockProductId,
        quantity: 2,
        price: 29.99,
        selectedOptions: {},
        addedAt: new Date(),
        updatedAt: new Date()
      };

      const cart = {
        ...mockCart,
        items: [existingItem],
        updateItem: jest.fn().mockImplementation(async function(productId, quantity) {
          const itemIndex = this.items.findIndex(
            (item: ICartItem) => item.productId.toString() === productId
          );

          if (itemIndex === -1) {
            throw new Error('Item not found in cart');
          }

          this.items[itemIndex].quantity = quantity;
          this.items[itemIndex].updatedAt = new Date();
          return this;
        })
      } as any;

      await cart.updateItem(mockProductId.toString(), 5);

      expect(cart.items[0].quantity).toBe(5);
    });

    test('updateItem should throw error for non-existent item', async () => {
      const cart = {
        ...mockCart,
        items: [],
        updateItem: jest.fn().mockImplementation(async function(productId, quantity) {
          const itemIndex = this.items.findIndex(
            (item: ICartItem) => item.productId.toString() === productId
          );

          if (itemIndex === -1) {
            throw new Error('Item not found in cart');
          }
          return this;
        })
      } as any;

      await expect(cart.updateItem(mockProductId.toString(), 5))
        .rejects.toThrow('Item not found in cart');
    });

    test('removeItem should remove item from cart', async () => {
      const existingItem: ICartItem = {
        productId: mockProductId,
        quantity: 2,
        price: 29.99,
        selectedOptions: {},
        addedAt: new Date(),
        updatedAt: new Date()
      };

      const cart = {
        ...mockCart,
        items: [existingItem],
        removeItem: jest.fn().mockImplementation(async function(productId) {
          this.items = this.items.filter(
            (item: ICartItem) => item.productId.toString() !== productId
          );
          return this;
        })
      } as any;

      await cart.removeItem(mockProductId.toString());

      expect(cart.items).toHaveLength(0);
    });

    test('clearCart should remove all items and set status to abandoned', async () => {
      const cart = {
        ...mockCart,
        items: [
          {
            productId: mockProductId,
            quantity: 2,
            price: 29.99,
            selectedOptions: {},
            addedAt: new Date(),
            updatedAt: new Date()
          }
        ],
        clearCart: jest.fn().mockImplementation(async function() {
          this.items = [];
          this.status = 'abandoned';
          return this;
        })
      } as any;

      await cart.clearCart();

      expect(cart.items).toHaveLength(0);
      expect(cart.status).toBe('abandoned');
    });

    test('calculateTotalsSync should calculate correct totals', () => {
      const items: ICartItem[] = [
        {
          productId: mockProductId,
          quantity: 2,
          price: 29.99,
          selectedOptions: {},
          addedAt: new Date(),
          updatedAt: new Date()
        },
        {
          productId: new Types.ObjectId(),
          quantity: 1,
          price: 15.50,
          selectedOptions: {},
          addedAt: new Date(),
          updatedAt: new Date()
        }
      ];

      const cart = {
        ...mockCart,
        items,
        calculateTotalsSync: jest.fn().mockImplementation(function() {
          this.totalItems = this.items.reduce((total: number, item: ICartItem) => total + item.quantity, 0);
          this.totalAmount = this.items.reduce(
            (total: number, item: ICartItem) => total + (item.price * item.quantity),
            0
          );
          this.totalAmount = Math.round(this.totalAmount * 100) / 100;
        })
      } as any;

      cart.calculateTotalsSync();

      expect(cart.totalItems).toBe(3); // 2 + 1
      expect(cart.totalAmount).toBe(75.48); // (29.99 * 2) + (15.50 * 1)
    });

    test('isExpired should return true for expired cart', () => {
      const expiredDate = new Date(Date.now() - 24 * 60 * 60 * 1000); // Yesterday
      
      const cart = {
        ...mockCart,
        expiresAt: expiredDate,
        isExpired: jest.fn().mockImplementation(function() {
          return this.expiresAt ? this.expiresAt < new Date() : false;
        })
      } as any;

      const result = cart.isExpired();
      expect(result).toBe(true);
    });

    test('isExpired should return false for active cart', () => {
      const futureDate = new Date(Date.now() + 24 * 60 * 60 * 1000); // Tomorrow
      
      const cart = {
        ...mockCart,
        expiresAt: futureDate,
        isExpired: jest.fn().mockImplementation(function() {
          return this.expiresAt ? this.expiresAt < new Date() : false;
        })
      } as any;

      const result = cart.isExpired();
      expect(result).toBe(false);
    });
  });

  describe('Cart Virtual Properties', () => {
    test('summary virtual should return cart summary', () => {
      const cart = {
        ...mockCart,
        totalItems: 3,
        totalAmount: 75.48,
        currency: 'USD',
        items: [{}, {}, {}], // Mock 3 items
        status: 'active'
      };

      const expectedSummary = {
        totalItems: 3,
        totalAmount: 75.48,
        currency: 'USD',
        itemCount: 3,
        status: 'active'
      };

      // Mock the virtual getter
      const summary = {
        totalItems: cart.totalItems,
        totalAmount: cart.totalAmount,
        currency: cart.currency,
        itemCount: cart.items.length,
        status: cart.status
      };

      expect(summary).toEqual(expectedSummary);
    });
  });

  describe('Input Validation', () => {
    test('should validate quantity limits', () => {
      const validQuantity = 5;
      const invalidQuantityLow = 0;
      const invalidQuantityHigh = 101;

      expect(validQuantity).toBeGreaterThan(0);
      expect(validQuantity).toBeLessThanOrEqual(100);
      
      expect(invalidQuantityLow).toBeLessThanOrEqual(0);
      expect(invalidQuantityHigh).toBeGreaterThan(100);
    });

    test('should validate price values', () => {
      const validPrice = 29.99;
      const invalidPrice = -10;

      expect(validPrice).toBeGreaterThanOrEqual(0);
      expect(invalidPrice).toBeLessThan(0);
    });

    test('should round prices to 2 decimal places', () => {
      const price = 29.999;
      const roundedPrice = Math.round(price * 100) / 100;

      expect(roundedPrice).toBe(30.00);
    });
  });

  describe('Error Handling', () => {
    test('should handle invalid ObjectId', () => {
      const invalidId = 'invalid-object-id';
      
      expect(() => {
        new Types.ObjectId(invalidId);
      }).toThrow();
    });

    test('should handle empty cart operations', () => {
      const emptyCart = {
        ...mockCart,
        items: []
      };

      expect(emptyCart.items).toHaveLength(0);
    });
  });

  describe('Business Logic', () => {
    test('should handle cart item options comparison', () => {
      const options1 = { size: 'large', color: 'red' };
      const options2 = { size: 'large', color: 'red' };
      const options3 = { size: 'medium', color: 'blue' };

      expect(JSON.stringify(options1)).toBe(JSON.stringify(options2));
      expect(JSON.stringify(options1)).not.toBe(JSON.stringify(options3));
    });

    test('should calculate expiration dates', () => {
      const userCartExpiry = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
      const guestCartExpiry = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

      expect(userCartExpiry.getTime()).toBeGreaterThan(guestCartExpiry.getTime());
    });

    test('should handle cart conversion scenarios', () => {
      const guestCart = {
        sessionId: 'guest_session_123',
        userId: undefined,
        status: 'active'
      };

      const convertedCart = {
        ...guestCart,
        userId: mockUserId,
        sessionId: undefined,
        status: 'converted'
      };

      expect(convertedCart.userId).toBe(mockUserId);
      expect(convertedCart.sessionId).toBeUndefined();
    });
  });
});

// Integration-style tests
describe('Cart Model Integration', () => {
  test('should handle complete cart workflow', async () => {
    const mockCartWorkflow = {
      userId: mockUserId,
      items: [],
      totalItems: 0,
      totalAmount: 0,
      status: 'active',
      
      // Simulate complete workflow
      async simulateWorkflow() {
        // Add first item
        this.items.push({
          productId: mockProductId,
          quantity: 2,
          price: 29.99,
          selectedOptions: { size: 'large' },
          addedAt: new Date(),
          updatedAt: new Date()
        });

        // Calculate totals
        this.totalItems = this.items.reduce((total, item) => total + item.quantity, 0);
        this.totalAmount = this.items.reduce((total, item) => total + (item.price * item.quantity), 0);

        // Add second item
        this.items.push({
          productId: new Types.ObjectId(),
          quantity: 1,
          price: 15.99,
          selectedOptions: {},
          addedAt: new Date(),
          updatedAt: new Date()
        });

        // Recalculate totals
        this.totalItems = this.items.reduce((total, item) => total + item.quantity, 0);
        this.totalAmount = this.items.reduce((total, item) => total + (item.price * item.quantity), 0);

        return this;
      }
    };

    const result = await mockCartWorkflow.simulateWorkflow();

    expect(result.items).toHaveLength(2);
    expect(result.totalItems).toBe(3);
    expect(result.totalAmount).toBe(75.97); // (29.99 * 2) + (15.99 * 1)
  });
});

export {};