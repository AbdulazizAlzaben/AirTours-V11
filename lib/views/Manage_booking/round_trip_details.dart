// ignore_for_file: use_build_context_synchronously

import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/services/cloud/firebase_cloud_storage.dart';
import 'package:AirTours/views/Manage_booking/tickets_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_flight.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_error.dart';
import '../../utilities/show_feedback.dart';
import '../Global/global_var.dart';
import '../Global/payment_page.dart';
import '../Global/ticket.dart';

class RoundTripDetails extends StatefulWidget {
  final CloudBooking booking;
  final CloudFlight depFlight;
  final CloudFlight retFlight;

  const RoundTripDetails({
    super.key,
    required this.booking,
    required this.depFlight,
    required this.retFlight,
  });

  @override
  State<RoundTripDetails> createState() => _RoundTripDetailsState();
}

class _RoundTripDetailsState extends State<RoundTripDetails> {
  late final BookingFirestore _bookingService;
  late final CloudFlight departFlight;
  late final CloudFlight retuFlight;
  late final CloudBooking currentBooking;
  late final FlightFirestore _flightsService;
  late String bookingType;
  List<Ticket> tickets = [];
  FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    departFlight = widget.depFlight;
    retuFlight = widget.retFlight;
    currentBooking = widget.booking;
    _flightsService = FlightFirestore();
    bookingType = currentBooking.bookingClass;
  }

  String date1(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    String monthName = monthNames[month - 1];
    String day = parts[1];
    // String year = parts[2];
    return '$day $monthName'; //$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsView(
                          booking: widget.booking, flight: widget.depFlight),
                    ));
              },
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Destination Flight",
                                style: TextStyle(fontSize: 22),
                              ),

                              // Text(
                              //   date1(departFlight.depDate),
                              //   style: const TextStyle(
                              //     fontSize: 17,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ],
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.black,
                            width: double.infinity,
                            //child: SizedBox.expand(),
                          ),
                          Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Departure: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        )),
                                    Text(
                                      date1(departFlight.depDate),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // const Text("-"),
                                Row(
                                  children: [
                                    const Text("Arrival: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        )),
                                    Text(
                                      date1(departFlight.arrDate),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.depFlight.fromCity,
                                  style: const TextStyle(fontSize: 19),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Image.asset('images/flight-Icon.png'),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.depFlight.toCity,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _flightsService
                                              .formatTime(departFlight.depTime),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                          child: Text("-"),
                                        ),
                                        Text(
                                          _flightsService
                                              .formatTime(departFlight.arrTime),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "Pasenger: ${widget.booking.numOfSeats}")
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ]),
                        ],
                      )))),
          const SizedBox(height: 16.0),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsView(
                          booking: widget.booking, flight: widget.retFlight),
                    ));
              },
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Return Flight",
                                style: TextStyle(fontSize: 22),
                              ),
                              //   Text(
                              //     date1(retuFlight.depDate),
                              //     style: const TextStyle(
                              //       fontSize: 17,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.black,
                            width: double.infinity,
                            //child: SizedBox.expand(),
                          ),
                          Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Departure: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        )),
                                    Text(
                                      date1(retuFlight.depDate),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // const Text("-"),
                                Row(
                                  children: [
                                    const Text("Arrival: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        )),
                                    Text(
                                      date1(retuFlight.arrDate),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.retFlight.fromCity,
                                  style: const TextStyle(fontSize: 19),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Image.asset('images/flight-Icon.png'),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.retFlight.toCity,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _flightsService
                                              .formatTime(retuFlight.depTime),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                          child: Text("-"),
                                        ),
                                        Text(
                                          _flightsService
                                              .formatTime(retuFlight.arrTime),
                                        ),
                                        // Text("${widget.booking.bookingPrice}")
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "Passenger: ${widget.booking.numOfSeats}")
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ]),
                        ],
                      )))),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Visibility(
                    visible: bookingType != 'Business',
                    child: ElevatedButton(
                      onPressed: () async {
                        if (await _flightsService.didFly(
                            departureFlightId: departFlight.documentId)) {
                          bool? nextPage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Payment(
                                    paymentFor: 'upgrade',
                                    id1: 'none',
                                    id2: 'none',
                                    flightClass: 'none',
                                    tickets: tickets)),
                          );
                          if (nextPage == true) {
                            bool result =
                                await _bookingService.upgradeRoundTrip(
                              bookingId: currentBooking.documentId,
                              departureFlightId: departFlight.documentId,
                              returnFlightId: retuFlight.documentId,
                              numOfPas: currentBooking.numOfSeats,
                            );

                            if (result == true) {
                              setState(() {
                                showSuccessDialog(
                                    context, 'Booking successfully upgraded.');
                                bookingType = 'Business';
                              });
                            } else {
                              showErrorDialog(
                                  context, 'Failed to upgrade booking.');
                            }
                          } else {
                            showErrorDialog(context, 'Payment Failed');
                          }
                        } else {
                          showErrorDialog(context,
                              'Cannot Upgrade Booking, Upgradation Deadline Passed');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Upgrade Booking',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      final canceledBookingPrice = await c
                          .canceledBookingPrice(currentBooking.documentId);
                      bool result = await _bookingService.deleteBooking(
                          bookingId: currentBooking.documentId,
                          flightId1: departFlight.documentId,
                          flightId2: retuFlight.documentId,
                          flightClass: currentBooking.bookingClass,
                          numOfPas: currentBooking.numOfSeats);

                      if (result == true) {
                        c.retrievePreviousBalance(
                            FirebaseAuthProvider.authService().currentUser!.id,
                            canceledBookingPrice);
                        showSuccessDialog(
                            context, 'Booking successfully deleted.');
                        Navigator.pop(context);
                      } else {
                        showErrorDialog(context,
                            "Cannot Cancel Booking, Cancellation Deadline Passed");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
