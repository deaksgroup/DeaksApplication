import 'dart:async';

import 'package:deaksapp/providers/Hotel.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:deaksapp/screens/home/home_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  final VoidCallback refresh;
  const SearchField({
    Key? key,
    required this.refresh,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? debounce;
  bool _isInit = false;
  bool _isLoading = false;
  String searchWord = "";
  String sortType = "All Jobs";

  void handleSearch(String value) {
    if (debounce != null) debounce?.cancel();
    setState(() {
      debounce = Timer(Duration(milliseconds: 300), () {
        searchWord = SearchInputController.text;
        _isInit = true;

        print("debounce");
        didChangeDependencies();
        //call api or other search functions here
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> searchQuery = {
        "shiftName": searchWord,
        "sortType": sortType,
        "Hotels": SelectedHotelList.toString(),
        "Tags": SelectedTagsList.toString(),
        "subscribed": isFliterBySubscriptions.toString(),
        "limit": "20"
      };

      Provider.of<Slots>(context, listen: false)
          .fetchAndSetSlots(searchQuery)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).then((value) {
        widget.refresh();
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController SearchInputController = TextEditingController();
  bool isSorting = false;
  bool isFiltering = false;
  int sort = 1;
  bool isFliterByTags = false;
  bool isFliterByHotel = false;
  bool isFliterBySubscriptions = false;
  bool viewSearchOptions = false;

  List<String> Tags = ["Open", "Full ( Waiting List )", "Closed"];
  List<String> Hotels = ["RITZ CARLTON", "PARK ROYAL"];
  List<String> SelectedHotelList = [];
  List<String> SelectedTagsList = [];
  void openFilterDialogForTags() async {
    await FilterListDialog.display<String>(
      context,
      listData: Tags,
      hideSearchField: true,
      hideHeader: true,
      selectedListData: SelectedTagsList,
      choiceChipLabel: (tag) => tag,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (tag, query) {
        return tag!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          isFliterByTags = true;
          _isInit = true;
          SelectedTagsList = List.from(list!);
          didChangeDependencies();
          // print(SelectedTagsList);
          if (SelectedTagsList.isEmpty) {
            isFliterByTags = false;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  void openFilterDialogForHotels() async {
    await FilterListDialog.display<String>(
      context,
      listData: Hotels,
      hideSearchField: true,
      hideHeader: true,
      selectedListData: SelectedHotelList,
      choiceChipLabel: (Hotel) => Hotel,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (Hotel, query) {
        return Hotel!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          isFliterByHotel = true;
          _isInit = true;
          SelectedHotelList = List.from(list!);
          didChangeDependencies();
          // print(SelectedHotelList);
          if (SelectedHotelList.isEmpty) {
            isFliterByHotel = false;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: SearchInputController,
            onChanged: (value) {
              handleSearch(value);
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(10),
                    vertical: getProportionateScreenWidth(10)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search Jobs ...",
                hintStyle:
                    TextStyle(color: Colors.grey.withOpacity(.7), fontSize: 14),
                suffixIcon: _isLoading
                    ? Transform.scale(
                        scale: .5,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 1,
                        ),
                      )
                    : Icon(
                        Icons.search,
                        color: Colors.grey.withOpacity(.7),
                      )),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     TextButton(
        //         onPressed: (() {
        //           setState(() {
        //             if (isSorting) {
        //               isSorting = false;
        //             } else {
        //               isFiltering = false;
        //               isSorting = true;
        //             }
        //           });
        //         }),
        //         child: Text(
        //           "Sort",
        //           style: TextStyle(
        //               color: sort == 0
        //                   ? Colors.blueGrey
        //                   : Colors.blue.withOpacity(1),
        //               fontSize: 12),
        //         )),
        //     TextButton(
        //         onPressed: (() {
        //           setState(() {
        //             if (isFiltering) {
        //               isFiltering = false;
        //             } else {
        //               isSorting = false;
        //               isFiltering = true;
        //             }
        //           });
        //         }),
        //         child: Text("Filter By",
        //             style: TextStyle(
        //                 color: isFliterByHotel ||
        //                         isFliterByTags ||
        //                         isFliterBySubscriptions
        //                     ? Colors.blue
        //                     : Colors.blueGrey,
        //                 fontSize: 12)))
        //   ],
        // ),
        if (isSorting)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(left: 10, bottom: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(.2)))),
            width: double.infinity,
            height: 141,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: (() {
                        if (sort != 1)
                          setState(() {
                            sort = 1;
                            sortType = "All jobs";
                            _isInit = true;
                            didChangeDependencies();
                          });
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Text(
                          "All Jobs",
                          style: TextStyle(
                              color: sort == 1 ? Colors.blue : Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: (() {
                        if (sort != 2)
                          setState(() {
                            sort = 2;
                            sortType = "Latest Jobs";
                            _isInit = true;
                            didChangeDependencies();
                          });
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          "Latest Jobs",
                          style: TextStyle(
                              color: sort == 2 ? Colors.blue : Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: (() {
                        if (sort != 3)
                          setState(() {
                            sort = 3;
                            sortType = "Hourly Pay";
                            _isInit = true;
                            didChangeDependencies();
                          });
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          "Hourly Pay",
                          style: TextStyle(
                              color: sort == 3 ? Colors.blue : Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: (() {
                        if (sort != 4)
                          setState(() {
                            sort = 4;
                            sortType = "Job Date";
                            _isInit = true;
                            didChangeDependencies();
                          });
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          "Job Date",
                          style: TextStyle(
                              color: sort == 4 ? Colors.blue : Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: (() {
                        if (sort != 5)
                          setState(() {
                            sort = 5;
                            sortType = "Morning To Evening";
                            _isInit = true;
                            didChangeDependencies();
                          });
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          "Morning To Evening",
                          style: TextStyle(
                              color: sort == 5 ? Colors.blue : Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          ),
        if (isFiltering)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(.2)))),
            width: double.infinity,
            height: 40,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    child: GestureDetector(
                  onTap: openFilterDialogForTags,
                  child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Tags",
                        style: TextStyle(
                            color:
                                isFliterByTags ? Colors.blue : Colors.blueGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
                Container(
                    child: GestureDetector(
                  onTap: openFilterDialogForHotels,
                  child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                      child: Text(
                        "Hotel",
                        style: TextStyle(
                            color:
                                isFliterByHotel ? Colors.blue : Colors.blueGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
                Container(
                    child: GestureDetector(
                  onTap: (() {
                    setState(() {
                      if (isFliterBySubscriptions) {
                        isFliterBySubscriptions = false;
                        _isInit = true;
                        didChangeDependencies();
                      } else {
                        isFliterBySubscriptions = true;
                        _isInit = true;
                        didChangeDependencies();
                      }
                    });
                  }),
                  child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                      child: Text(
                        "Subscribed",
                        style: TextStyle(
                            color: isFliterBySubscriptions
                                ? Colors.blue
                                : Colors.blueGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
      ]),
    );
  }
}
