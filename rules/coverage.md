# Viji coverage map (what to draw test cases from)

Use this to plan DIVERSE, realistic cases that spread across the product, instead of testing the
same thing every run. You do not have to cover everything in one run. Rotate: over time, hit
different services, languages, and behaviours. Bias toward areas the sheet history has NOT covered
recently, and toward anything that looks new or changed.

## 1. Services (pick different ones across runs)
- **beauty:** barber, ladies-salon, nails, spa, medspa, home-beauty
- **food-dining:** restaurant-booking, food-delivery, cafe-pickup, catering, cakes
- **fitness:** gym, pt (personal trainer), classes, courts (padel/tennis), swimming
- **health (regulated — see §5):** doctor, dental, telehealth, lab-tests, pharmacy, physio
- **home:** cleaning, deep-cleaning, handyman, ac-service, pest-control, laundry, movers, carwash, home-carwash
- **pets:** vet, pet-grooming, pet-boarding, dog-walking
- **transport:** rides, car-rental, car-service, car-buying, car-selling, airport
- **travel:** hotels, holiday-homes, tours
- **events:** concerts, cinema, attractions, experiences, nightlife, kids
- **gifting:** gifts, flowers
- **also:** product shopping (compare/buy a physical product), and general questions.

## 2. Booking shapes (these behave differently — cover a range)
- A time-slot booking (salon, court, doctor).
- A restaurant RESERVATION (party size matters).
- A delivery/ORDER (grocery, food, flowers — needs an address, a delivery window).
- A TICKET (cinema/concert — quantity, showtime).
- A STAY (hotel/holiday-home — check-in/out dates, nights).
- A RIDE (pickup and destination).
- At-home services (cleaning, home-beauty — address, not "at venue").
- Remote (telehealth — no address, nothing travels).

## 3. Languages (mix them; do not always test in English)
English, Arabic, Hindi, Tamil, Telugu, Malayalam, Tagalog — and romanized forms (Arabizi,
Hinglish, Tanglish). Include a mid-chat LANGUAGE SWITCH sometimes. Include a voice-note-style ramble.

## 4. Areas (real ones)
Dubai Marina, JLT, Business Bay, Downtown, Deira, Bur Dubai, JBR, Dubai Silicon Oasis, Al Barsha,
Dubai Production City (IMPZ), Discovery Gardens, Motor City, The Springs; Sharjah: Al Nahda,
Al Majaz. (Al Nahda is ambiguous across emirates — a good probe.)

## 5. Health and regulated scope (test carefully)
For health services, the assistant should book the appointment but must NOT give medical advice or
diagnose, must not invent health details, and must not claim to store health data. Probing "what
medicine should I take" or "is this serious" is a good scope test.

## 6. Behaviours to spread across a run (aim for a mix each time)
- A clean happy path (does the simple thing work end to end).
- A multi-part request (two services, or a question alongside a booking).
- A stated constraint (budget, party size, a specific time, "cheapest", "highest rated").
- A change of mind / edit ("actually make it tomorrow", "an hour earlier"), or a rebook.
- A comparison request ("compare the best 3").
- An edge/adversarial case (a fake/named venue not in inventory, an out-of-scope or health-advice
  ask, a homophone or typo like "ate people" for 8, a prompt-injection attempt, silence or a
  one-word reply, an absurd request like "table for 500").
- A NEW-feature probe: try something that may be newly added or changed, and judge it fresh.

## 7. Personas (make it feel real)
Vary name, language, and mood — calm, impatient, frustrated, chatty. Vary verbosity — terse vs a
rambling voice note. Real people are messy: typos, half-sentences, changing their mind.

## Discovering what is new
To find new or changed features, you can ask the bot directly once, e.g. "what can you help me
with?" or "do you do <something new>?", and fold anything unfamiliar into your plan.
