import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/booking_list_component.dart';
import 'package:handyman_provider_flutter/components/dropdown_status_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/booking_status_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BookingFragment extends StatefulWidget {
  String? statusType;

  BookingFragment({this.statusType});

  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  int page = 1;
  List<BookingData> mainList = [];

  String selectedValue = 'All';
  bool isLastPage = false;
  bool hasError = false;
  bool isApiCalled = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    LiveStream().on(HandyBoardStream, (index) {
      if (index == 1) {
        selectedValue = BookingStatusKeys.accept;
        fetchAllBookingList(status: selectedValue);
      }
    });
    LiveStream().on(handymanAllBooking, (index) {
      if (index == 1) {
        selectedValue = '';
        fetchAllBookingList(status: selectedValue);
      }
    });

    LiveStream().on(LiveStreamUpdateBookings, (p0) {
      page = 1;
      fetchAllBookingList(status: selectedValue);
    });
    if (widget.statusType.validate().isNotEmpty) {
      selectedValue = widget.statusType.validate();
    }

    fetchAllBookingList(status: selectedValue, loading: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isLastPage) {
          page++;
          fetchAllBookingList(status: selectedValue);
        }
      }
    });
  }

  Future<void> fetchAllBookingList({required String status, bool loading = true}) async {
    appStore.setLoading(loading);

    await getBookingList(page, status: status).then((value) {
      appStore.setLoading(false);
      isApiCalled = true;

      if (page == 1) {
        mainList.clear();
      }
      mainList.addAll(value.data.validate());
      selectedValue = status;

      isLastPage = value.pagination?.totalPages == page;

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      isApiCalled = true;

      toast(e.toString(), print: true);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();

    LiveStream().dispose(LiveStreamUpdateBookings);
    LiveStream().dispose(HandyBoardStream);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          page = 1;
          return await fetchAllBookingList(status: selectedValue, loading: true);
        },
        child: Stack(
          children: [
            if (mainList.isNotEmpty)
              ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: mainList.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (_, index) => BookingListComponent(bookingData: mainList[index], index: index),
              ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76),
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: DropdownStatusComponent(
                isValidate: false,
                statusType: selectedValue,
                onValueChanged: (BookingStatusResponse value) {
                  page = 1;
                  scrollController.animToTop();
                  fetchAllBookingList(status: value.value.toString());
                },
              ),
            ),
            Observer(
              builder: (_) => noDataFound(context).center().visible(!appStore.isLoading && mainList.validate().isEmpty && isApiCalled),
            ),
            Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading),
            )
          ],
        ),
      ),
    );
  }
}
