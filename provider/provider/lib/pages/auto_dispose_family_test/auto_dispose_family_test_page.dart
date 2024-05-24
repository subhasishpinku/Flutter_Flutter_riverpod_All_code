import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/pages/auto_dispose_family_test/auto_dispose_family_test_provider.dart';

// class AutoDisposeFamilyTestPage extends ConsumerWidget {
//   const AutoDisposeFamilyTestPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final hellojohn = ref.watch(autoDiposeFamilyTestHelloProvider('john'));
//     final hellojane = ref.watch(autoDiposeFamilyTestHelloProvider('jane'));
//     ref.watch(counterProvider(const Counter(count: 0)));
//     ref.watch(counterProvider(const Counter(count: 0)));

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AutoDisposeFamilyTestProvider'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               hellojohn,
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               hellojane,
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class AutoDisposeFamilyTestPage extends ConsumerStatefulWidget {
  const AutoDisposeFamilyTestPage ({super.key});

  @override
  ConsumerState<AutoDisposeFamilyTestPage> createState() => _AutoDisposeFamilyTestPageState();
}

class _AutoDisposeFamilyTestPageState extends ConsumerState<AutoDisposeFamilyTestPage> {
  String name =  'john';
  @override
  Widget build(BuildContext context) {
    final helloThere = ref.watch(autoDiposeFamilyTestHelloProvider(name));
      return Scaffold(
      appBar: AppBar(
        title: const Text('AutoDisposeFamilyTestProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              helloThere,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
           const SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: (){
              setState(() {
                name = name == 'john' ? 'jane' : 'john';
              });
            },
             child: const Text(
              'change Name'
             ))
          ],
        ),
      ),
    );
  }
}