/**
 * Cart Route Module
 * 
 * Exports the main cart router for the DeliverGaz application.
 * This module provides comprehensive shopping cart functionality including:
 * - Add items to cart with quantity management
 * - Update item quantities in existing cart
 * - Remove specific items or clear entire cart
 * - Retrieve cart details and summary information
 * - User authentication and cart isolation
 * - Swagger documentation
 * 
 * @module routes/cart
 */

import cartRouter from './cart.route';

export default cartRouter;
export { cartRouter };