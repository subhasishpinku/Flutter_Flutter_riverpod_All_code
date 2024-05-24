import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/pages/auto_dispose_family/auto_dispose_family_provider.dart';

class AutoDisposeFamilyPage extends ConsumerWidget {
  const AutoDisposeFamilyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final helloJohn = ref.watch(autoDiposeFamilyProvider('john'));
    // final helloJane = ref.watch(autoDiposeFamilyProvider('jane'));
     final helloJohn = ref.watch(autoDisposeFamilyHelloProvider(there: 'john'));
    final helloJane = ref.watch(autoDisposeFamilyHelloProvider(there: 'john'));
    ref.watch(counterProvider(const Counter(count: 0)));
    ref.watch(counterProvider(const Counter(count: 0)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoDisposeFamilyProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              helloJohn,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              helloJane,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}


// class AutoDisposeFamilyPage extends StatelessWidget {
//   const AutoDisposeFamilyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AutoDisposeFamilyProvider'),
//       ),
//       body: const Center(
//         child: Text('AutoDisposeFamilyProvider'),
//       ),
//     );
//   }
// }