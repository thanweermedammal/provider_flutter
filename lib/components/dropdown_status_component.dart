import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/booking_status_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class DropdownStatusComponent extends StatefulWidget {
  final Function(String)? callBack;
  final String? statusType;

  final Function(BookingStatusResponse value) onValueChanged;
  final bool isValidate;

  DropdownStatusComponent({this.callBack, required this.onValueChanged, required this.isValidate, this.statusType});

  @override
  _DropdownStatusComponentState createState() => _DropdownStatusComponentState();
}

class _DropdownStatusComponentState extends State<DropdownStatusComponent> {
  String status = '';
  AsyncMemoizer<List<BookingStatusResponse>> statusMemoizer = AsyncMemoizer();
  BookingStatusResponse? selectedData;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    LiveStream().on(HandyBoardStream, (index) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(HandyBoardStream);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingStatusResponse>>(
      future: statusMemoizer.runOnce(() => bookingStatus()),
      builder: (context, snap) {
        if (snap.hasData) {
          if (!snap.data!.any((element) => element.id == 0)) {
            snap.data!.insert(0, BookingStatusResponse(label: 'All', id: 0, status: 0, value: "All"));
          }
          if (widget.statusType.validate().isNotEmpty) {
            snap.data.validate().forEach((e) {
              if (e.label.validate().toLowerCase() == widget.statusType.validate().toLowerCase()) {
                selectedData = e;
              }
            });
          } else {
            selectedData = snap.data!.first;
          }
          return DropdownButtonFormField<BookingStatusResponse>(
            onChanged: (BookingStatusResponse? val) {
              widget.onValueChanged.call(val!);
            },
            validator: widget.isValidate
                ? (c) {
                    if (c == null) return errorThisFieldRequired;
                    return null;
                  }
                : null,
            value: selectedData,
            dropdownColor: context.cardColor,
            decoration: inputDecoration(context),
            items: List.generate(
              snap.data!.length,
              (index) {
                BookingStatusResponse data = snap.data![index];
                return DropdownMenuItem<BookingStatusResponse>(
                  child: Text(data.label.toString(), style: primaryTextStyle()),
                  value: data,
                );
              },
            ),
          );
        }
        return snapWidgetHelper(snap, defaultErrorMessage: "", loadingWidget: SizedBox());
      },
    );
  }
}
