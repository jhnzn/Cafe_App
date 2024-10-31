import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataTransaksi extends StatefulWidget {
  const DataTransaksi({super.key});

  @override
  State<DataTransaksi> createState() => _DataTransaksiState();
}

class _DataTransaksiState extends State<DataTransaksi> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> transactions = [
    {"date": DateTime(2024, 9, 19), "description": "Kam"},
    {"date": DateTime(2024, 9, 20), "description": "Jum"},
    {"date": DateTime(2024, 9, 21), "description": "Sab"},
    {"date": DateTime(2024, 9, 22), "description": "Ming"},
    {"date": DateTime(2024, 9, 23), "description": "Sen"},
  ];

  List<DateTime> getMonthList() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month - 6);
    DateTime endDate = DateTime(currentDate.year, currentDate.month + 6);

    List<DateTime> monthList = [];

    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = DateTime(date.year, date.month + 1)) {
      monthList.add(date);
    }
    return monthList;
  }
//woi kenapa ini woiiiiiii
 Widget buildMonthYearText(DateTime date) {
  String month = DateFormat("MMMM").format(date);
  String year = DateFormat("yyyy").format(date);
  return Container(
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: month,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF057350),
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: year,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Color(0xFF057350),
            ),
          ),
        ],
      ),
    ),
  );
}


  List<Map<String, dynamic>> getFilteredTransactions() {
    return transactions.where((transaction) {
      return transaction["date"].year == selectedDate.year &&
          transaction["date"].month == selectedDate.month;
    }).toList();
  }

  DateTime? selectedTransactionDate;

  @override
  Widget build(BuildContext context) {
    List<DateTime> monthList = getMonthList();

    if (!monthList.contains(selectedDate)) {
      selectedDate = monthList.first;
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          DropdownButton<DateTime>(
            value: selectedDate,
            underline: const SizedBox(),
            items: monthList.map((DateTime value) {
              return DropdownMenuItem<DateTime>(
                value: value,
                child: buildMonthYearText(value),
              );
            }).toList(),
            onChanged: (DateTime? newValue) {
              setState(() {
                selectedDate = newValue!;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...getFilteredTransactions().map((transaction) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTransactionDate = transaction["date"];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      width: 50,
                      height: 67,
                      decoration: BoxDecoration(
                        color: selectedTransactionDate == transaction["date"]
                            ? const Color(0xFF057350)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd').format(transaction["date"]),
                              style: TextStyle(
                                color: selectedTransactionDate ==
                                        transaction["date"]
                                    ? Colors.white
                                    : const Color(0xFF057350),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              transaction["description"],
                              style: TextStyle(
                                color: selectedTransactionDate ==
                                        transaction["date"]
                                    ? Colors.white
                                    : const Color(0xFF057350),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top:50),
              decoration: const BoxDecoration(
                color: Color(0xFF057350),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: selectedTransactionDate == null
                    ? const Center(
                        child: Text(
                          'Tidak ada data transaksi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            "09.00 - 15.00",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/nota');
                            },
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Card(
                                        color: Color(0xFFE6F8F7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            'Lunas',
                                            style: TextStyle(
                                              color: Color(0xFF5BA890),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Trisha perwira',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Banana Milkshake',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '1x',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/nota');
                            },
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Card(
                                        color: Color(0xFFE6F8F7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            'Lunas',
                                            style: TextStyle(
                                              color: Color(0xFF5BA890),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Aulia',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Banana Milkshake',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '1x',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Cinnamon tea',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '1x',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Beef Mushroom Pizza',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '1x',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "15.00 - 21.00",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/nota');
                            },
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Card(
                                        color: Color(0xFFE6F8F7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            'Lunas',
                                            style: TextStyle(
                                              color: Color(0xFF5BA890),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Revy Adel',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Banana Milkshake',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '1x',
                                          style: TextStyle(
                                            color: Color(0xFFAEAEAE),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
