/**
 * Cart Module Index
 * Exports all cart-related functionality
 */

// Export the main model
export { default as Cart, ICart, ICartItem } from './cart.model';

// Export examples for reference
export { default as CartExamples } from './cart.model.example';

// Re-export for convenience
export * from './cart.model';