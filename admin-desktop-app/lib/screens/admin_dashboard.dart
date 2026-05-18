import 'package:flutter/material.dart';

class Shipment {
  final String id;
  final String date;
  String status; // 'Pending', 'In Transit', 'Out for Delivery', 'Delivered'
  final double total;
  final String items;
  final String origin;
  final String destination;
  final String pin;
  final String time;

  Shipment({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    required this.origin,
    required this.destination,
    required this.pin,
    required this.time,
  });
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Shipment> _shipments = [
    Shipment(
      id: 'PK-10582',
      date: 'Today, 10:23 AM',
      status: 'In Transit',
      total: 464.00,
      items: 'Noise-Canceling Headphones, Sneakers',
      origin: 'Tech Haven & Sneaker Hub',
      destination: '1423 Logic Avenue, City Center',
      pin: '8902',
      time: '11:45 AM',
    ),
    Shipment(
      id: 'PK-09214',
      date: 'Oct 12, 2023',
      status: 'Delivered',
      total: 120.00,
      items: 'Urban Minimalist Jacket',
      origin: 'Style Central Depot',
      destination: '782 Fashion Boulevard',
      pin: '4391',
      time: '03:15 PM',
    ),
    Shipment(
      id: 'PK-08831',
      date: 'Oct 05, 2023',
      status: 'Delivered',
      total: 45.50,
      items: 'Organic Fresh Produce Box',
      origin: 'Green Earth Farms',
      destination: '304 Maplewood Lane',
      pin: '7720',
      time: '12:10 PM',
    ),
    Shipment(
      id: 'PK-11048',
      date: 'Yesterday, 04:50 PM',
      status: 'Pending',
      total: 299.00,
      items: 'Leather Designer Boots',
      origin: 'Premium Leather House',
      destination: '556 Oakwood Crescent',
      pin: '1098',
      time: '--:--',
    ),
    Shipment(
      id: 'PK-12490',
      date: 'Today, 08:15 AM',
      status: 'Out for Delivery',
      total: 850.00,
      items: 'Ultra-Wide Smart Monitor',
      origin: 'Electronics Hub West',
      destination: '908 Tech District Drive',
      pin: '5012',
      time: '02:00 PM',
    ),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Stats calculation methods
  int get _totalActive => _shipments.where((s) => s.status != 'Delivered').length;
  int get _totalDelivered => _shipments.where((s) => s.status == 'Delivered').length;
  double get _successRate {
    if (_shipments.isEmpty) return 100.0;
    return (_totalDelivered / _shipments.length) * 100.0;
  }
  int get _alertsCount => _shipments.where((s) => s.status == 'Pending').length;

  @override
  Widget build(BuildContext context) {
    final filteredShipments = _shipments.where((s) {
      final matchesSearch = s.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.items.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.destination.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_selectedFilter == 'All') return matchesSearch;
      if (_selectedFilter == 'Active') return matchesSearch && s.status != 'Delivered';
      if (_selectedFilter == 'Delivered') return matchesSearch && s.status == 'Delivered';
      if (_selectedFilter == 'Pending') return matchesSearch && s.status == 'Pending';
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Elegant Branded Dark Header
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0F172A),
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AMU Courier Control Room'.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Central Logistics Console',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withAlpha(50),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.circle, color: Colors.green, size: 8),
                                SizedBox(width: 8),
                                Text(
                                  'SYS ACTIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Stat Cards Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard('Active Shipments', '$_totalActive', Icons.local_shipping, const Color(0xFF3B82F6)),
                      _buildStatCard('Delivered Today', '$_totalDelivered', Icons.check_circle_rounded, const Color(0xFF10B981)),
                      _buildStatCard('Success Rate', '${_successRate.toStringAsFixed(1)}%', Icons.show_chart, const Color(0xFF6366F1)),
                      _buildStatCard('Alerts / Idle', '$_alertsCount', Icons.warning_amber_rounded, const Color(0xFFF59E0B)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Search and Filtering Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search shipments by ID, items...',
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Active', 'Delivered', 'Pending'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(filter, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
                            selected: isSelected,
                            selectedColor: const Color(0xFF0F172A),
                            backgroundColor: Colors.white,
                            onSelected: (val) {
                              if (val) setState(() => _selectedFilter = filter);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Real-time Logistics Queue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Shipment Queue List
          filteredShipments.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text('No shipments found matching filters', style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final shipment = filteredShipments[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFF3B82F6).withAlpha(50), width: 1),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF2563EB)),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'Order #${shipment.id}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(shipment.status),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${shipment.date} • ${shipment.items}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        shipment.destination,
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${shipment.total.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                            ],
                          ),
                          onTap: () => _showFulfillmentDetails(context, shipment),
                        ),
                      );
                    },
                    childCount: filteredShipments.length,
                  ),
                ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),

      // Sidebar Drawer
      drawer: Drawer(
        backgroundColor: const Color(0xFF0F172A),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Alex Kumar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'System Operator',
                        style: TextStyle(color: Colors.blue[400], fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded, color: Colors.white70),
              title: const Text('Logistics Dashboard', style: TextStyle(color: Colors.white70)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_rounded, color: Colors.white30),
              title: const Text('Manage Personnel', style: TextStyle(color: Colors.white30)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.location_city_rounded, color: Colors.white30),
              title: const Text('Hub Networks', style: TextStyle(color: Colors.white30)),
              onTap: () {},
            ),
            const Spacer(),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Log Out Console', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // Close Drawer
                Navigator.pop(context); // Logout
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // Create Shipment Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateParcelDialog,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Register Parcel', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: accentColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
              Icon(icon, color: accentColor.withAlpha(150), size: 20),
            ],
          ),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'Delivered':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        break;
      case 'In Transit':
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1E40AF);
        break;
      case 'Out for Delivery':
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF6B21A8);
        break;
      default:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showFulfillmentDetails(BuildContext context, Shipment shipment) {
    final steps = [
      {'id': 0, 'label': 'Pending', 'icon': Icons.inventory_2_outlined, 'desc': 'Order received'},
      {'id': 1, 'label': 'In Transit', 'icon': Icons.local_shipping_outlined, 'desc': 'En route to local hub'},
      {'id': 2, 'label': 'Out for Delivery', 'icon': Icons.directions_run_outlined, 'desc': 'Assigned to driver'},
      {'id': 3, 'label': 'Delivered', 'icon': Icons.check_circle_outline_rounded, 'desc': 'Successfully delivered'},
    ];

    int getActiveStepIndex() {
      if (shipment.status == 'Pending') return 0;
      if (shipment.status == 'In Transit') return 1;
      if (shipment.status == 'Out for Delivery') return 2;
      return 3;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int currentStep = getActiveStepIndex();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Live Fulfillment Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text('Tracking Number: ${shipment.id}', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF3B82F6).withAlpha(20), shape: BoxShape.circle),
                        child: const Icon(Icons.share_location_rounded, color: Color(0xFF2563EB)),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pin Code Sidebar widget recreated beautifully
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.verified_user_rounded, color: Colors.blueAccent),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Handover PIN', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('Provide to Courier', style: TextStyle(color: Colors.white38, fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          shipment.pin,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Interactive visual timeline
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      final id = step['id'] as int;
                      final isCompleted = currentStep >= id;
                      final isActive = currentStep == id;

                      return GestureDetector(
                        onTap: () {
                          // Interactive Demo simulation
                          String newStatus = 'Pending';
                          if (id == 1) newStatus = 'In Transit';
                          if (id == 2) newStatus = 'Out for Delivery';
                          if (id == 3) newStatus = 'Delivered';

                          setState(() {
                            shipment.status = newStatus;
                          });
                          setModalState(() {});
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isCompleted ? const Color(0xFF2563EB) : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isCompleted ? const Color(0xFF2563EB) : Colors.grey.shade300,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Icon(
                                    step['icon'] as IconData,
                                    size: 14,
                                    color: isCompleted ? Colors.white : Colors.grey.shade400,
                                  ),
                                ),
                                if (index < steps.length - 1)
                                  Container(
                                    width: 3,
                                    height: 36,
                                    color: currentStep > id ? const Color(0xFF2563EB) : Colors.grey.shade200,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step['label'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? const Color(0xFF2563EB)
                                          : isCompleted
                                              ? const Color(0xFF0F172A)
                                              : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    step['desc'] as String,
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                            Text(
                              isCompleted
                                  ? (id == 0 ? '10:23 AM' : (id == 1 ? shipment.time : (id == 2 ? '02:00 PM' : '03:15 PM')))
                                  : 'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCompleted ? Colors.black54 : Colors.grey.shade300,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Close Console', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateParcelDialog() {
    final itemsController = TextEditingController();
    final valueController = TextEditingController();
    final destinationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Register New Parcel', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemsController,
                decoration: const InputDecoration(labelText: 'Items (e.g. Mechanical Keyboard)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Declared Value (USD)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: destinationController,
                decoration: const InputDecoration(labelText: 'Destination Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final items = itemsController.text.trim();
                final valueStr = valueController.text.trim();
                final destination = destinationController.text.trim();

                if (items.isEmpty || valueStr.isEmpty || destination.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final val = double.tryParse(valueStr) ?? 0.0;
                final newId = 'PK-${12500 + _shipments.length}';

                setState(() {
                  _shipments.insert(
                    0,
                    Shipment(
                      id: newId,
                      date: 'Today, 03:00 PM',
                      status: 'Pending',
                      total: val,
                      items: items,
                      origin: 'AMU Courier Center',
                      destination: destination,
                      pin: '${1000 + _shipments.length * 37}',
                      time: '--:--',
                    ),
                  );
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registered parcel $newId successfully!')),
                );
              },
              child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

