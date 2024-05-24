import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/pages/family/family_provider.dart';

class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hellojohn = ref.watch(familyHelloProvider('john'));
    final hellojane = ref.watch(familyHelloProvider('jane'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('FamilyProvider'),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(hellojohn,
             style: Theme.of(context).textTheme.headlineLarge,),
             const SizedBox(height: 10,),
               Text(hellojane,
             style: Theme.of(context).textTheme.headlineLarge,),
          ],
        ),
      ),
    );
  }
}


// class FamilyPage extends StatelessWidget {
//   const FamilyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FamilyProvider'),
//       ),
//       body: const Center(
//         child: Text('FamilyProvider'),
//       ),
//     );
//   }
// }