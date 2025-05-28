import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:madurai_flutter_app/screens/api_tester_screen.dart';
import 'package:madurai_flutter_app/screens/expense_screen.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Assistant'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Center(
              child: Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(top: 24, bottom: 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            
            // Welcome text
            Text(
              'Welcome to Gemini Assistant',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your AI assistant powered by Google\'s Gemini language model. Ask questions, get creative responses, and more!',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Feature cards
            Text(
              'What can Gemini do?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Fixed height GridView with shrinkWrap
            SizedBox(
              height: 300, // Fixed height for the grid
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
                children: [
                  _buildFeatureCard(
                    context,
                    Icons.help_outline,
                    'Answer Questions',
                    'Get information on virtually any topic'
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.lightbulb_outline,
                    'Creative Writing',
                    'Generate stories, poems, and other creative text'
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.translate,
                    'Translation',
                    'Translate between different languages'
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.code,
                    'Programming Help',
                    'Get coding examples and explanations'
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Buttons section - Now properly visible
            Column(
              children: [
                // Start chat button
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to chat screen using bottom navigation
                    DefaultTabController.of(context).animateTo(1);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text(
                    'Start Chatting',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Bluetooth SOS button
                ElevatedButton.icon(
                  onPressed: () {
                    _navigateToBluetoothScreen(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.bluetooth_connected),
                  label: const Text(
                    'Connect Bluetooth Device for SOS',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Expense Tracker button
                ElevatedButton.icon(
                  onPressed: () {
                    _navigateToExpenseTrackerScreen(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: const Color.fromARGB(255, 96, 32, 234),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text(
                    'Open Expense Tracker',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                 ElevatedButton.icon(
                  onPressed: () {
                    _navigateToAPITesterScreen(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: const Color.fromARGB(255, 63, 134, 84),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text(
                    'Open API Tester',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],

              
            ),
            
            // Add some bottom padding for better scrolling experience
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _navigateToBluetoothScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BluetoothDeviceScreen(),
      ),
    );
  }

  void _navigateToExpenseTrackerScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpenseScreen(),
      ),
    );
  }

  void _navigateToAPITesterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApiTesterScreen(),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bluetooth Device Screen Class
class BluetoothDeviceScreen extends StatefulWidget {
  const BluetoothDeviceScreen({super.key});

  @override
  State<BluetoothDeviceScreen> createState() => _BluetoothDeviceScreenState();
}

class _BluetoothDeviceScreenState extends State<BluetoothDeviceScreen> {
  List<ScanResult> _scanResults = [];
  List<BluetoothDevice> _connectedDevices = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  BluetoothDevice? _connectedDevice;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    // Request permissions
    await _requestPermissions();
    
    // Check if Bluetooth is supported
    if (await FlutterBluePlus.isSupported == false) {
      _showSnackBar('Bluetooth not supported by this device');
      return;
    }

    // Get current adapter state
    _adapterState = await FlutterBluePlus.adapterState.first;
    
    // Listen to adapter state changes
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _adapterState = state;
      });
      if (state == BluetoothAdapterState.off) {
        _scanResults.clear();
        _connectedDevices.clear();
      }
    });

    // Get already connected devices
    _getConnectedDevices();
    
    setState(() {});
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.location,
    ].request();
  }

  Future<void> _getConnectedDevices() async {
    try {
      List<BluetoothDevice> devices = FlutterBluePlus.connectedDevices;
      setState(() {
        _connectedDevices = devices;
      });
    } catch (e) {
      print('Error getting connected devices: $e');
    }
  }

  Future<void> _startScan() async {
    if (_adapterState != BluetoothAdapterState.on) {
      _showSnackBar('Please turn on Bluetooth first');
      return;
    }

    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    try {
      // Start scanning
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      
      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _scanResults = results;
        });
      });

      // Wait for scan to complete
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
      
      setState(() {
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      _showSnackBar('Error during scan: $e');
    }
  }

  Future<void> _stopScan() async {
    await FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
    }

    setState(() {
      _isConnecting = true;
    });

    try {
      await device.connect();
      setState(() {
        _isConnecting = false;
        _connectedDevice = device;
      });
      _showSnackBar('Connected to ${device.platformName.isNotEmpty ? device.platformName : device.remoteId}');
      
      // Listen for disconnection
      device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.disconnected) {
          setState(() {
            _connectedDevice = null;
          });
          _showSnackBar('Disconnected from device');
        }
      });

      // Discover services (optional)
      List<BluetoothService> services = await device.discoverServices();
      print('Services discovered: ${services.length}');
      
    } catch (e) {
      setState(() {
        _isConnecting = false;
      });
      _showSnackBar('Failed to connect: $e');
    }
  }

  Future<void> _disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      setState(() {
        _connectedDevice = null;
      });
      _showSnackBar('Disconnected');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildDeviceListTile(BluetoothDevice device, {bool isConnected = false}) {
    String deviceName = device.platformName.isNotEmpty ? device.platformName : 'Unknown Device';
    bool isCurrentlyConnected = _connectedDevice?.remoteId == device.remoteId;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.bluetooth,
          color: isCurrentlyConnected ? Colors.green : Colors.grey,
        ),
        title: Text(
          deviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.remoteId.toString()),
            if (isConnected) 
              const Text(
                'Connected',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
          ],
        ),
        trailing: _isConnecting
            ? const CircularProgressIndicator()
            : isCurrentlyConnected
                ? ElevatedButton(
                    onPressed: _disconnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Disconnect'),
                  )
                : ElevatedButton(
                    onPressed: () => _connectToDevice(device),
                    child: const Text('Connect'),
                  ),
      ),
    );
  }

  Widget _buildScanResultTile(ScanResult result) {
    return _buildDeviceListTile(result.device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_adapterState == BluetoothAdapterState.on)
            IconButton(
              icon: Icon(_isScanning ? Icons.stop : Icons.search),
              onPressed: _isScanning ? _stopScan : _startScan,
            ),
        ],
      ),
      body: Column(
        children: [
          // Bluetooth Status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _adapterState == BluetoothAdapterState.on
                ? Colors.green.shade100
                : Colors.red.shade100,
            child: Row(
              children: [
                Icon(
                  Icons.bluetooth,
                  color: _adapterState == BluetoothAdapterState.on
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bluetooth: ${_adapterState == BluetoothAdapterState.on ? 'ON' : 'OFF'}',
                  style: TextStyle(
                    color: _adapterState == BluetoothAdapterState.on
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_connectedDevice != null) ...[
                  const Spacer(),
                  Text(
                    'Connected: ${_connectedDevice!.platformName.isNotEmpty ? _connectedDevice!.platformName : _connectedDevice!.remoteId}',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Scanning Status
          if (_isScanning)
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Scanning for devices...'),
                ],
              ),
            ),
          
          // Device Lists
          Expanded(
            child: ListView(
              children: [
                // Connected Devices Section
                if (_connectedDevices.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Connected Devices',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._connectedDevices.map(
                    (device) => _buildDeviceListTile(device, isConnected: true),
                  ),
                ],
                
                // Scan Results Section
                if (_scanResults.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Available Devices',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._scanResults.map(_buildScanResultTile),
                ],
                
                // Empty State
                if (_connectedDevices.isEmpty && _scanResults.isEmpty && !_isScanning)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.bluetooth_disabled,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No devices found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the search icon to discover devices',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _adapterState == BluetoothAdapterState.on
          ? FloatingActionButton(
              onPressed: _isScanning ? _stopScan : _startScan,
              backgroundColor: Colors.blue,
              child: Icon(
                _isScanning ? Icons.stop : Icons.search,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                if (await FlutterBluePlus.isSupported) {
                  // On some devices, we can request to turn on Bluetooth
                  await FlutterBluePlus.turnOn();
                } else {
                  _showSnackBar('Please turn on Bluetooth manually');
                }
              },
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.bluetooth_disabled,
                color: Colors.white,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _connectedDevice?.disconnect();
    super.dispose();
  }
}