import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -- Your imports go here --
// Update these paths to match your project structure:
import 'package:spacy_notes/providers/market_providers/market_firebase_service.dart';
import 'package:spacy_notes/providers/user_provider.dart';

/// This dialog asks the user to confirm a purchase.
class PurchaseDialog extends StatelessWidget {
  final String itemName;
  final int itemPrice;
  final int userBalance;
  final VoidCallback onBuy;
  final VoidCallback onCancel;

  const PurchaseDialog({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.userBalance,
    required this.onBuy,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF2C1C5B),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase $itemName?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Current Balance: \$$userBalance',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset('images/currency.png', width: 24, height: 24),
                    const SizedBox(width: 6),
                    Text(
                      '\$$itemPrice',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('CANCEL'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onBuy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('YES'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A wrapper that fetches the current user and shows [PurchaseDialog].
class PurchaseDialogWrapper extends ConsumerWidget {
  final ItemType itemType;
  final String itemId;
  final String itemTitle;
  final String itemPrice;

  const PurchaseDialogWrapper({
    super.key,
    required this.itemType,
    required this.itemId,
    required this.itemTitle,
    required this.itemPrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Center(child: Text('Not logged in'));
        }

        return PurchaseDialog(
          itemName: itemTitle,
          itemPrice: int.parse(itemPrice),
          userBalance: user.balance,
          onCancel: () => Navigator.of(context).pop(),
          onBuy: () async {
            try {
              await purchaseItem(
                userId: user.uid,
                itemType: itemType,
                itemId: itemId,
                price: int.parse(itemPrice),
              );
              Navigator.of(context).pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

/// Call this to display the dialog anywhere in your app.
void showPurchaseDialog(
  BuildContext context, {
  required ItemType itemType,
  required String itemId,
  required String itemTitle,
  required String itemPrice,
}) {
  showDialog(
    context: context,
    builder: (_) => PurchaseDialogWrapper(
      itemType: itemType,
      itemId: itemId,
      itemTitle: itemTitle,
      itemPrice: itemPrice,
    ),
  );
}
