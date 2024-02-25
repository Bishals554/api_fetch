import 'package:api_fetch/model/data_model.dart';
import 'package:api_fetch/provider/data_provider.dart';
import 'package:api_fetch/provider/loading_provider.dart';
import 'package:api_fetch/provider/search_provider.dart';
import 'package:api_fetch/provider/sort_provider.dart';
import 'package:api_fetch/src/widgets/custom_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userData = ref.watch(userDataProvider);
    textController.text = ref.watch(searchQueryProvider);
    final sortingOrder = ref.watch(sortingOrderProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                focusNode: focusNode,
                controller: textController,
                onChanged: (value) {
                  ref
                      .read(searchQueryProvider.notifier)
                      .update((state) => state = value);
                },
                onEditingComplete: () {},
                onTapOutside: (event) {
                  focusNode.unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Search By Name',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                        textController.clear();
                        focusNode.unfocus();
                        Future.delayed(const Duration(milliseconds: 1), () {
                          return ref.refresh(searchQueryProvider);
                        });
                      },
                      child: const Icon(
                        Icons.clear_outlined,
                        size: 20,
                      )),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Row(
              children: [
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem(
                        value: 'Default',
                        child: Text('Default'),
                      ),
                      PopupMenuItem(
                        value: 'Ascending',
                        child: Text('Ascending'),
                      ),
                      PopupMenuItem(
                        value: 'Descending',
                        child: Text('Descending'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    ref.read(sortingOrderProvider.notifier).state = value;
                  },
                ),
                if (sortingOrder == 'Ascending')
                  const Text(
                    'a-z',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                if (sortingOrder == 'Descending')
                  const Text(
                    'z-a',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
              ],
            ),
          ],
        ),
      ),
      body: userData.when(
        data: (userData) {
          List<UserData?> userDataList =
              userData!.data!.map((element) => element).toList();
          if (sortingOrder == 'Ascending') {
            userDataList
                .sort((a, b) => a!.employeeName!.compareTo(b!.employeeName!));
          } else if (sortingOrder == 'Descending') {
            userDataList
                .sort((a, b) => b!.employeeName!.compareTo(a!.employeeName!));
          }
          final filteredList = userDataList.where((element) => element!
              .employeeName!
              .toLowerCase()
              .contains(textController.text));
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 5), () {
                return ref.refresh(userDataProvider);
              });
            },
            child: Scrollbar(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  NumberFormat formatter = NumberFormat.decimalPatternDigits(
                    locale: 'en_us',
                    decimalDigits: 0,
                  );
                  String amount = (formatter
                      .format(filteredList.elementAt(index)!.employeeSalary));
                  return CustomList(
                    id: filteredList.elementAt(index)!.id ?? 0,
                    employeeName:
                        filteredList.elementAt(index)!.employeeName ?? '',
                    employeeSalary: amount,
                    employeeAge:
                        filteredList.elementAt(index)!.employeeAge ?? 0,
                    profileImage:
                        filteredList.elementAt(index)!.profileImage ?? '',
                  );
                },
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Error while fetching api'),
              ref.watch(retryStateProvider)
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        ref.read(retryStateProvider.notifier).state = true;
                        await Future.delayed(const Duration(seconds: 4), () {
                          userData = ref.refresh(userDataProvider);
                        });
                        ref.read(retryStateProvider.notifier).state = false;
                      },
                      child: const Text('Retry'),
                    ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
