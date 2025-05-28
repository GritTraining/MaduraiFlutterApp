import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTesterScreen extends StatefulWidget {
  const ApiTesterScreen({super.key});
  @override
  _ApiTesterScreenState createState() => _ApiTesterScreenState();
}

class _ApiTesterScreenState extends State<ApiTesterScreen> {
  final _urlController = TextEditingController();
  final _bodyController = TextEditingController();
  
  String _selectedMethod = 'GET';
  List<MapEntry<String, String>> _headers = [];
  List<MapEntry<String, String>> _params = [];
  
  String _response = '';
  int _statusCode = 0;
  Map<String, String> _responseHeaders = {};
  bool _isLoading = false;
  
  final List<String> _methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

  @override
  void initState() {
    super.initState();
    // Add default headers
    _headers.add(MapEntry('Content-Type', 'application/json'));
  }

  void _addHeader() {
    setState(() {
      _headers.add(MapEntry('', ''));
    });
  }

  void _removeHeader(int index) {
    setState(() {
      _headers.removeAt(index);
    });
  }

  void _addParam() {
    setState(() {
      _params.add(MapEntry('', ''));
    });
  }

  void _removeParam(int index) {
    setState(() {
      _params.removeAt(index);
    });
  }

  String _buildUrlWithParams() {
    String url = _urlController.text.trim();
    if (_params.isEmpty) return url;
    
    List<String> validParams = _params
        .where((param) => param.key.isNotEmpty && param.value.isNotEmpty)
        .map((param) => '${Uri.encodeComponent(param.key)}=${Uri.encodeComponent(param.value)}')
        .toList();
    
    if (validParams.isNotEmpty) {
      String separator = url.contains('?') ? '&' : '?';
      url += separator + validParams.join('&');
    }
    
    return url;
  }

  Future<void> _makeRequest() async {
    if (_urlController.text.trim().isEmpty) {
      _showSnackBar('Please enter a URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
      _statusCode = 0;
      _responseHeaders = {};
    });

    try {
      String url = _buildUrlWithParams();
      Uri uri = Uri.parse(url);
      
      // Prepare headers
      Map<String, String> headers = {};
      for (var header in _headers) {
        if (header.key.isNotEmpty && header.value.isNotEmpty) {
          headers[header.key] = header.value;
        }
      }

      http.Response response;
      
      switch (_selectedMethod) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
          );
          break;
        default:
          response = await http.get(uri, headers: headers);
      }

      setState(() {
        _statusCode = response.statusCode;
        _responseHeaders = response.headers;
        
        // Try to format JSON response
        try {
          var jsonResponse = json.decode(response.body);
          _response = JsonEncoder.withIndent('  ').convert(jsonResponse);
        } catch (e) {
          _response = response.body;
        }
      });
      
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _statusCode = 0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color _getStatusColor() {
    if (_statusCode >= 200 && _statusCode < 300) return Colors.green;
    if (_statusCode >= 400) return Colors.red;
    if (_statusCode >= 300) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Tester'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // URL and Method Section
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Request', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedMethod,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: _methods.map((method) {
                                    return DropdownMenuItem(
                                      value: method,
                                      child: Text(method),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMethod = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _urlController,
                                  decoration: InputDecoration(
                                    labelText: 'URL',
                                    border: OutlineInputBorder(),
                                    hintText: 'https://api.example.com/users',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Parameters Section
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Query Parameters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: _addParam,
                              ),
                            ],
                          ),
                          ..._params.asMap().entries.map((entry) {
                            int index = entry.key;
                            MapEntry<String, String> param = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: param.key,
                                      decoration: InputDecoration(
                                        labelText: 'Key',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onChanged: (value) {
                                        _params[index] = MapEntry(value, param.value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: param.value,
                                      decoration: InputDecoration(
                                        labelText: 'Value',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onChanged: (value) {
                                        _params[index] = MapEntry(param.key, value);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeParam(index),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Headers Section
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Headers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: _addHeader,
                              ),
                            ],
                          ),
                          ..._headers.asMap().entries.map((entry) {
                            int index = entry.key;
                            MapEntry<String, String> header = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: header.key,
                                      decoration: InputDecoration(
                                        labelText: 'Header Key',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onChanged: (value) {
                                        _headers[index] = MapEntry(value, header.value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: header.value,
                                      decoration: InputDecoration(
                                        labelText: 'Header Value',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onChanged: (value) {
                                        _headers[index] = MapEntry(header.key, value);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeHeader(index),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Request Body Section (for POST, PUT, PATCH)
                  if (['POST', 'PUT', 'PATCH'].contains(_selectedMethod))
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Request Body', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _bodyController,
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '{"key": "value"}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  SizedBox(height: 16),
                  
                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _makeRequest,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Send Request', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Response Section
                  if (_response.isNotEmpty || _isLoading)
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Response', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Spacer(),
                                if (_statusCode > 0)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Status: $_statusCode',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Response Headers
                            if (_responseHeaders.isNotEmpty) ...[
                              Text('Response Headers:', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _responseHeaders.entries
                                      .map((e) => '${e.key}: ${e.value}')
                                      .join('\n'),
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                            
                            // Response Body
                            Text('Response Body:', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxHeight: 300),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  _response.isEmpty ? 'No response yet' : _response,
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}