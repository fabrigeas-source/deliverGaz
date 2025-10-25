import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const String _filterAll = 'All';
  static const String _sortDate = 'Date';
  static const String _sortStatus = 'Status';
  static const String _sortTotal = 'Total';
  static const String _sortID = 'ID';
  
  String _selectedFilter = _filterAll;
  String _sortBy = _sortDate;
  bool _sortAscending = false;
  
  final OrdersApiClient _apiClient = OrdersApiClient();
  List<Order> _allOrders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final orders = await _apiClient.fetchOrders(
        status: _selectedFilter == _filterAll ? null : _selectedFilter,
        sortBy: _sortBy,
        ascending: _sortAscending,
      );

      setState(() {
        _allOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createTestOrder() async {
    final i10n = AppLocalizations.of(context)!;
    try {
      final newOrder = await _apiClient.createOrder(
        total: 125.99,
        items: [i10n.gasCylinder13kg, i10n.gasRegulator, i10n.gasHose2m],
      );

      await _loadOrders(); // Refresh the list

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(i10n.testOrderCreated(newOrder.id)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(i10n.failedToCreateOrder(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Order> get _filteredAndSortedOrders {
    List<Order> filtered = _allOrders;
    
    // Apply filter
    if (_selectedFilter != _filterAll) {
      filtered = filtered.where((order) => order.status == _selectedFilter).toList();
    }
    
    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case _sortDate:
          comparison = a.date.compareTo(b.date);
          break;
        case _sortStatus:
          comparison = a.status.compareTo(b.status);
          break;
        case _sortTotal:
          comparison = a.total.compareTo(b.total);
          break;
        case _sortID:
          comparison = a.id.compareTo(b.id);
          break;
        default:
          comparison = a.date.compareTo(b.date);
      }
      return _sortAscending ? comparison : -comparison;
    });
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filteredAndSortedOrders;
    final i10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.myOrders),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'refresh':
                  await _loadOrders();
                  if (mounted) {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(
                      SnackBar(content: Text(i10n.refreshOrders)),
                    );
                  }
                  break;
                case 'create_test':
                  await _createTestOrder();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    const Icon(Icons.refresh),
                    const SizedBox(width: 8),
                    Text(i10n.refreshOrders),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'create_test',
                child: Row(
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text(i10n.createTestOrder),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Tabs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFilterTab(i10n.all, _allOrders.length, Colors.blue),
                    _buildFilterTab(i10n.delivered, _allOrders.where((o) => o.status == 'Delivered').length, Colors.green),
                    _buildFilterTab(i10n.inTransit, _allOrders.where((o) => o.status == 'In Transit').length, Colors.orange),
                    _buildFilterTab(i10n.cancelled, _allOrders.where((o) => o.status == 'Cancelled').length, Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Sort Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  i10n.showingOrders(filteredOrders.length),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _sortBy,
                      underline: Container(),
                      items: [
                        DropdownMenuItem<String>(
                          value: _sortDate,
                          child: Text(i10n.sortByDate),
                        ),
                        DropdownMenuItem<String>(
                          value: _sortStatus,
                          child: Text(i10n.sortByStatus),
                        ),
                        DropdownMenuItem<String>(
                          value: _sortTotal,
                          child: Text(i10n.sortByTotal),
                        ),
                        DropdownMenuItem<String>(
                          value: _sortID,
                          child: Text(i10n.sortByID),
                        ),
                      ],
                      onChanged: _isLoading ? null : (String? newValue) async {
                        setState(() {
                          _sortBy = newValue!;
                        });
                        await _loadOrders();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 20,
                      ),
                      onPressed: _isLoading ? null : () async {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                        await _loadOrders();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Orders List
            Expanded(
              child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading orders...'),
                      ],
                    ),
                  )
                : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading orders',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadOrders,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : filteredOrders.isEmpty 
                    ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedFilter == 'All' 
                            ? 'You haven\'t placed any orders yet'
                            : 'No ${_selectedFilter.toLowerCase()} orders found',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(order.status).withOpacity(0.2),
                        child: Icon(
                          _getStatusIcon(order.status),
                          color: _getStatusColor(order.status),
                        ),
                      ),
                      title: Text('Order #${order.id}'),
                      subtitle: Text(
                        '${_formatDate(order.date)} • ${order.status}',
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Items:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, size: 6, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(item),
                                  ],
                                ),
                              )),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (order.status == 'In Transit')
                                    ElevatedButton.icon(
                                      onPressed: () => _trackOrder(order),
                                      icon: const Icon(Icons.location_on),
                                      label: const Text('Track Order'),
                                    ),
                                  if (order.status == 'Delivered')
                                    ElevatedButton.icon(
                                      onPressed: () => _reorderItems(order),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Reorder'),
                                    ),
                                  OutlinedButton.icon(
                                    onPressed: () => _viewOrderDetails(order),
                                    icon: const Icon(Icons.visibility),
                                    label: const Text('View Details'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String filter, int count, Color color) {
    bool isSelected = _selectedFilter == filter;
    
    return Expanded(
      child: InkWell(
        onTap: _isLoading ? null : () async {
          setState(() {
            _selectedFilter = filter;
          });
          await _loadOrders();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected 
              ? Border.all(color: color, width: 2)
              : Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: isSelected ? 26 : 22,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                filter == 'All' ? 'Total' : filter,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'In Transit':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Delivered':
        return Icons.check_circle;
      case 'In Transit':
        return Icons.local_shipping;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.shopping_bag;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _trackOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Track Order #${order.id}'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Order Confirmed'),
              subtitle: Text('Your order has been confirmed'),
            ),
            ListTile(
              leading: Icon(Icons.inventory, color: Colors.green),
              title: Text('Prepared for Shipping'),
              subtitle: Text('Your order is being prepared'),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.orange),
              title: Text('In Transit'),
              subtitle: Text('Your order is on the way'),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.grey),
              title: Text('Out for Delivery'),
              subtitle: Text('Will be delivered soon'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _reorderItems(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${order.items.length} items to cart for reorder'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Order ID', order.id),
                    _buildDetailRow('Date', '${order.date.day}/${order.date.month}/${order.date.year}'),
                    _buildDetailRow('Status', order.status),
                    _buildDetailRow('Total', '\$${order.total.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Items Ordered',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_basket),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}



// Dialog utility for quick orders view
class OrdersDialogUtils {
  static void showOrdersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.shopping_bag, color: Colors.orange),
              SizedBox(width: 8),
              Text('My Orders'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: Text('#${index + 1}'),
                    ),
                    title: Text('Order #${2024000 + index + 1}'),
                    subtitle: Text('Status: ${index % 2 == 0 ? 'Delivered' : 'In Transit'}'),
                    trailing: Text('\$${(25.99 * (index + 1)).toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersPage()),
                );
              },
              child: const Text('View All'),
            ),
          ],
        );
      },
    );
  }
}