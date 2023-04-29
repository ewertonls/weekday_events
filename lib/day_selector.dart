import 'package:flutter/material.dart';

class DaySelector extends StatefulWidget {
  const DaySelector({super.key});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  var selectedDate = DateTime.now();

  Iterable<DateTime> generateWeek({DateTime? date}) {
    final currentDate = date ?? DateTime.now();

    final dateWithoutTime = currentDate.subtract(
      Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond,
      ),
    );

    final firstWeekday = dateWithoutTime.subtract(
      Duration(days: dateWithoutTime.weekday % DateTime.daysPerWeek),
    );

    final weekdays = List.generate(
      DateTime.daysPerWeek,
      (day) => firstWeekday.add(Duration(days: day)),
    );

    return weekdays;
  }

  List<Iterable<DateTime>> get weeks => [
        generateWeek(),
        generateWeek(date: DateTime.now().add(const Duration(days: 7))),
      ];

  void selectWeekday(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: PageView.builder(
            itemCount: weeks.length,
            itemBuilder: (context, index) => WeekDays(
              weekDays: weeks[index],
              selected: selectedDate,
              onSelect: selectWeekday,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: List.generate(
              16,
              (index) => Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                margin: EdgeInsets.only(top: index != 0 ? 16 : 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Text('Evento do dia ${selectedDate.day}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WeekDays extends StatelessWidget {
  const WeekDays({
    super.key,
    required this.weekDays,
    required this.onSelect,
    required this.selected,
  });

  final Iterable<DateTime> weekDays;

  final DateTime selected;

  final void Function(DateTime) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekDays
          .map(
            (weekday) => Badge(
              label: const Text('16'),
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox.square(
                dimension: 48,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => onSelect(weekday),
                  child: Ink(
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: selected.day == weekday.day
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Center(child: Text(weekday.day.toString())),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
