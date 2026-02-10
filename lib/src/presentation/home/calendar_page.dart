import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/event_item.dart';
import '../../services/event_service.dart';
import 'widgets/event_card.dart';
import 'event_detail_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final EventService _eventService = EventService();
  List<EventItem> _allEvents = [];
  List<EventItem> _filteredEvents = [];
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _allEvents = _eventService.getImportantEvents();
      _filteredEvents = _allEvents;
    });
  }

  // Verifică dacă o zi are evenimente
  bool _hasEventOnDay(DateTime day) {
    return _allEvents.any((event) {
      final eventDate = _parseEventDate(event.date);
      return eventDate != null &&
          eventDate.year == day.year &&
          eventDate.month == day.month &&
          eventDate.day == day.day;
    });
  }

  // Parsează data din string
  DateTime? _parseEventDate(String dateString) {
    try {
      // Format: "24 Decembrie 2024"
      final parts = dateString.split(' ');
      if (parts.length >= 3) {
        final day = int.parse(parts[0]);
        final monthStr = parts[1];
        final year = int.parse(parts[2]);
        
        final months = {
          'Ianuarie': 1, 'Februarie': 2, 'Martie': 3, 'Aprilie': 4,
          'Mai': 5, 'Iunie': 6, 'Iulie': 7, 'August': 8,
          'Septembrie': 9, 'Octombrie': 10, 'Noiembrie': 11, 'Decembrie': 12,
        };
        
        final month = months[monthStr];
        if (month != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      // Ignoră erorile de parsare
    }
    return null;
  }

  // Filtrează evenimente pentru ziua selectată
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      
      // Filtrează evenimente pentru ziua selectată
      _filteredEvents = _allEvents.where((event) {
        final eventDate = _parseEventDate(event.date);
        return eventDate != null &&
            eventDate.year == selectedDay.year &&
            eventDate.month == selectedDay.month &&
            eventDate.day == selectedDay.day;
      }).toList();
      
      // Dacă nu sunt evenimente în ziua selectată, arată toate
      if (_filteredEvents.isEmpty) {
        _filteredEvents = _allEvents;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Calendar
          _buildCalendar(),
          
          const SizedBox(height: 20),
          
          // Titlu listă evenimente
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.event, color: navy, size: 24),
                const SizedBox(width: 12),
                Text(
                  _selectedDay != null
                      ? 'Evenimente din ${_selectedDay!.day}/${_selectedDay!.month}'
                      : 'Toate evenimentele',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: lightGrey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Listă evenimente verticală
          _buildEventsList(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: navy.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2026, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        
        // Style
        calendarStyle: CalendarStyle(
          // Zile normale
          defaultTextStyle: GoogleFonts.inter(color: lightGrey),
          weekendTextStyle: GoogleFonts.inter(color: beige),
          
          // Ziua de azi
          todayDecoration: BoxDecoration(
            color: navy.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          todayTextStyle: GoogleFonts.inter(
            color: lightGrey,
            fontWeight: FontWeight.bold,
          ),
          
          // Ziua selectată
          selectedDecoration: const BoxDecoration(
            color: navy,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: GoogleFonts.inter(
            color: lightGrey,
            fontWeight: FontWeight.bold,
          ),
          
          // Zile cu evenimente (marker)
          markerDecoration: const BoxDecoration(
            color: Color(0xFF123458),  // ✅ Navy (nu galben!)
            shape: BoxShape.circle,
          ),
        ),
        
        // Header style
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: lightGrey,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: lightGrey),
          rightChevronIcon: const Icon(Icons.chevron_right, color: lightGrey),
        ),
        
        // Days of week style
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(
            color: beige,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: GoogleFonts.inter(
            color: beige,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Event marker
        eventLoader: (day) {
          return _hasEventOnDay(day) ? ['event'] : [];
        },
      ),
    );
  }

  Widget _buildEventsList() {
    if (_filteredEvents.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Text(
          'Nu există evenimente în această zi',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: beige,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: _filteredEvents.map((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          child: SizedBox(
            height: 200,  // Înălțime fixă pentru carduri
            child: EventCard(
              event: event,
              onDetailsPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailPage(event: event),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}