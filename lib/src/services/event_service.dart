import '../models/event_item.dart';

class EventService {
  // Mock data pentru evenimente importante
  List<EventItem> getImportantEvents() {
    return [
      EventItem(
        id: '1',
        title: 'Program Duminică',
        date: '24 Decembrie 2024',
        time: '19:00',
        location: 'Biserica Geneza Oradea',
        description: 'Te invităm la un program special de închinare și predică din Cuvântul lui Dumnezeu. '
            'Vom avea un timp de rugăciune, închinare și comuniune împreună. '
            'Vino așa cum ești și lasă-te transformat de prezența lui Dumnezeu!',
        imageUrl: 'assets/images/event1.jpg',
        registrationLink: 'https://forms.gle/geneza-program-duminica',
      ),
      EventItem(
        id: '2',
        title: 'Program Crăciun',
        date: '25 Decembrie 2024',
        time: '10:00',
        location: 'Biserica Geneza Oradea',
        description: 'Celebrăm împreună nașterea Mântuitorului nostru, Isus Hristos! '
            'Un program special cu muzică, predică și activități pentru copii. '
            'Aducem laolaltă familiile pentru a sărbători cel mai frumos dar - dragostea lui Dumnezeu pentru noi.',
        imageUrl: 'assets/images/event2.jpg',
        registrationLink: 'https://forms.gle/geneza-craciun',
      ),
      EventItem(
        id: '3',
        title: 'Ski Camp',
        date: '15-17 Februarie 2025',
        time: '08:00',
        location: 'Poiana Brașov',
        description: 'O experiență de neuitat în munți pentru tineret! '
            'Trei zile de schi, snowboard, comuniune și timp cu Dumnezeu. '
            'Vom avea devoționale dimineața, timp liber pe pârtie și seri de worship la foc de tabără.',
        imageUrl: 'assets/images/event3.jpg',
        registrationLink: 'https://forms.gle/geneza-ski-camp',
        cost: '450 RON',
        whatToBring: [
          'Echipament schi/snowboard (sau închiriază la fața locului)',
          'Haine călduroase și impermeabile',
          'Buletin/CI pentru cazare',
          'Bani de buzunar (50-100 RON)',
          'Biblie și caiet de notițe',
        ],
      ),
    ];
  }

  // Metodă pentru toate evenimentele
  List<EventItem> getAllEvents() {
    return getImportantEvents();
  }

  // TODO: Firebase methods când adaugi backend
  // Future<List<EventItem>> getEventsFromFirestore() async { ... }
  // Future<void> createEvent(EventItem event) async { ... }
  // Future<void> updateEvent(EventItem event) async { ... }
  // Future<void> deleteEvent(String eventId) async { ... }
}