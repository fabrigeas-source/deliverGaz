# Mock API Routes Documentation

This project includes a mock API service that simulates a real REST API for managing orders

## Available API Routes

### Orders Endpoints

#### GET /api/orders
**Description:** Fetch all orders with optional filtering and sorting

**Parameters:**
- `status` (optional): Filter by order status ('All', 'Delivered', 'In Transit', 'Cancelled', 'Processing')
- `sortBy` (optional): Sort field ('Date', 'Status', 'Total', 'ID')
- `ascending` (optional): Sort direction (boolean, default: false)

**Usage:**
```dart
final orders = await OrdersApiClient().fetchOrders(
  status: 'Delivered',
  sortBy: 'Date',
  ascending: false,
);
```

#### GET /api/orders/:id
**Description:** Fetch a specific order by ID

**Usage:**
```dart
final order = await OrdersApiClient().fetchOrder('2024001');
```

#### POST /api/orders
**Description:** Create a new order

**Parameters:**
- `total` (required): Order total amount
- `items` (required): List of item names

**Usage:**
```dart
final newOrder = await OrdersApiClient().createOrder(
  total: 125.99,
  items: ['13kg Gas Cylinder', 'Gas Regulator'],
);
```

#### PUT /api/orders/:id
**Description:** Update order status

**Parameters:**
- `id` (required): Order ID
- `status` (required): New status

**Usage:**
```dart
final updatedOrder = await OrdersApiClient().updateOrderStatus('2024001', 'Delivered');
```

#### DELETE /api/orders/:id
**Description:** Cancel an order (sets status to 'Cancelled')

**Usage:**
```dart
await OrdersApiClient().cancelOrder('2024001');
```

### Statistics Endpoint

#### GET /api/orders/stats
**Description:** Get order statistics

**Returns:**
- `total`: Total number of orders
- `delivered`: Number of delivered orders
- `inTransit`: Number of orders in transit
- `cancelled`: Number of cancelled orders
- `processing`: Number of processing orders
- `totalRevenue`: Total revenue from delivered orders

**Usage:**
```dart
final stats = await OrdersApiClient().fetchOrderStats();
```

## Mock Data

The mock API comes pre-loaded with sample orders including:
- Gas cylinders (13kg, 9kg, 45kg)
- Accessories (regulators, hoses)
- Various order statuses
- Realistic dates and pricing

## Network Simulation

- All API calls include a 500ms delay to simulate network latency
- Error handling is built-in for testing
- Responses follow standard REST API patterns

## Usage in Flutter

The API is integrated into the Orders page and provides:
- Real-time filtering and sorting
- Loading states
- Error handling
- Refresh functionality
- Order creation

## Testing

Use the "Create Test Order" option in the Orders page menu to test the POST endpoint and see new orders added to the list.

## Implementation Details

- **MockApiService**: Core mock server implementation
- **OrdersApiClient**: Clean API interface for the UI
- **ApiResponse**: Generic response wrapper
- **ApiException**: Custom exception handling

The mock API is designed to be easily replaceable with a real REST API when ready for production.