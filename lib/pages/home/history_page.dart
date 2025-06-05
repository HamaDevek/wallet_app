import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_app/controllers/transaction_controller.dart';
import 'package:wallet_app/models/transactions_model.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  final TransactionController transactionController =
      Get.find<TransactionController>(tag: 'transaction');

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch both sent and received transactions when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionController.getSentTransactions();
      transactionController.getReceivedTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTransactionTitle(Transaction transaction, bool isSent) {
    if (transaction.type == 'recharge') {
      return 'Wallet Recharge';
    } else if (isSent) {
      return 'To ${transaction.receiver?.name ?? 'Unknown'}';
    } else {
      return 'From ${transaction.sender?.name ?? 'Unknown'}';
    }
  }

  IconData _getTransactionIcon(Transaction transaction, bool isSent) {
    if (transaction.type == 'recharge') {
      return Icons.add;
    }
    return isSent ? Icons.arrow_upward : Icons.arrow_downward;
  }

  Color _getTransactionIconColor(Transaction transaction, bool isSent) {
    if (transaction.type == 'recharge') {
      return Colors.blue;
    }
    return isSent ? Colors.red : Colors.green;
  }

  Color _getTransactionIconBgColor(Transaction transaction, bool isSent) {
    if (transaction.type == 'recharge') {
      return const Color(0xFFE3F2FD);
    }
    return isSent ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9);
  }

  String _getTransactionAmount(Transaction transaction, bool isSent) {
    final amount = transaction.amount ?? 0;
    if (transaction.type == 'recharge' || !isSent) {
      return '+$amount IQD';
    }
    return '-$amount IQD';
  }

  Color _getTransactionAmountColor(Transaction transaction, bool isSent) {
    if (transaction.type == 'recharge' || !isSent) {
      return Colors.green;
    }
    return Colors.red;
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  // Extract transactions from TransactionsModel list
  List<Transaction> _extractTransactions(
    List<TransactionsModel> transactionModels,
  ) {
    List<Transaction> allTransactions = [];
    for (var model in transactionModels) {
      if (model.data?.transactions != null) {
        allTransactions.addAll(model.data!.transactions!);
      }
    }
    return allTransactions;
  }

  Widget _buildTransactionList(
    List<TransactionsModel> transactionModels,
    bool isSent,
  ) {
    if (transactionController.isLoading.value && transactionModels.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final transactions = _extractTransactions(transactionModels);

    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(
                isSent ? Icons.arrow_upward : Icons.arrow_downward,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                isSent ? 'No sent transactions' : 'No received transactions',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSent
                    ? 'Transactions you send will appear here'
                    : 'Transactions you receive will appear here',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children:
          transactions.map((transaction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TransactionActivityItem(
                icon: _getTransactionIcon(transaction, isSent),
                iconColor: _getTransactionIconColor(transaction, isSent),
                iconBgColor: _getTransactionIconBgColor(transaction, isSent),
                title: _getTransactionTitle(transaction, isSent),
                subtitle: _formatDateTime(transaction.createdAt),
                amount: _getTransactionAmount(transaction, isSent),
                amountColor: _getTransactionAmountColor(transaction, isSent),
                description: transaction.description,
                status: transaction.status ?? 'completed',
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header with refresh button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      onPressed:
                          transactionController.isLoading.value
                              ? null
                              : () {
                                transactionController.getSentTransactions();
                                transactionController.getReceivedTransactions();
                              },
                      icon:
                          transactionController.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_upward, size: 18),
                        const SizedBox(width: 8),
                        const Text('Sent'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_downward, size: 18),
                        const SizedBox(width: 8),
                        const Text('Received'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab View
            Expanded(
              child: Obx(
                () => TabBarView(
                  controller: _tabController,
                  children: [
                    // Sent Transactions Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildTransactionList(
                        transactionController.sentTransactions,
                        true,
                      ),
                    ),
                    // Received Transactions Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildTransactionList(
                        transactionController.receivedTransactions,
                        false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final String? description;
  final String status;

  const TransactionActivityItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            status == 'completed'
                                ? Colors.green[50]
                                : status == 'pending'
                                ? Colors.orange[50]
                                : Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:
                              status == 'completed'
                                  ? Colors.green[700]
                                  : status == 'pending'
                                  ? Colors.orange[700]
                                  : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
