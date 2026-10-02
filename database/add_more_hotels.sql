USE staysphere;

-- =========================================================
-- StaySphere: Add more hotels to every city
-- Goal: 4 hotels per city = 48 hotels total
-- Safe to run more than once because each hotel has a unique slug.
-- =========================================================

INSERT INTO hotels
(city_id, name, slug, description, address, star_rating, property_type, cover_image, policies, featured)
SELECT
    c.id,
    x.name,
    x.slug,
    x.description,
    x.address,
    x.star_rating,
    x.property_type,
    x.cover_image,
    x.policies,
    x.featured
FROM (
    SELECT 'Delhi' city_name, 'Connaught Crown Hotel' name, 'connaught-crown-hotel' slug,
           'Modern premium stay close to central Delhi shopping, dining and business districts.' description,
           'Connaught Place, New Delhi' address, 4 star_rating, 'Hotel' property_type,
           'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image,
           'Government photo ID required at check-in.' policies, 1 featured
    UNION ALL
    SELECT 'Delhi','Aerocity Horizon','aerocity-horizon',
           'Contemporary airport-area hotel designed for business and transit travellers.',
           'Aerocity, New Delhi',4,'Hotel',
           'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80',
           'Valid photo ID required. Standard cancellation rules apply.',0

    UNION ALL
    SELECT 'Mumbai','Harbour Lights Mumbai','harbour-lights-mumbai',
           'Stylish city hotel with convenient access to South Mumbai attractions.',
           'Colaba, Mumbai',4,'Hotel',
           'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?auto=format&fit=crop&w=1200&q=80',
           'Valid ID required at check-in.',1
    UNION ALL
    SELECT 'Mumbai','Bandra Skyline Hotel','bandra-skyline-hotel',
           'Modern rooms for leisure and corporate guests in a lively Mumbai neighbourhood.',
           'Bandra West, Mumbai',5,'Hotel',
           'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80',
           'No smoking in rooms. Government ID required.',1

    UNION ALL
    SELECT 'Kolkata','Park Street Residency','park-street-residency',
           'Comfortable hotel close to restaurants, shopping and cultural attractions.',
           'Park Street, Kolkata',4,'Hotel',
           'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
           'Photo ID required at check-in.',1
    UNION ALL
    SELECT 'Kolkata','Salt Lake Grand','salt-lake-grand',
           'Contemporary business hotel near major offices and city conveniences.',
           'Sector V, Salt Lake, Kolkata',4,'Hotel',
           'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80',
           'Standard hotel rules and cancellation policy apply.',0

    UNION ALL
    SELECT 'Bengaluru','Indiranagar Urban Stay','indiranagar-urban-stay',
           'Trendy urban hotel surrounded by cafés, shopping and nightlife.',
           'Indiranagar, Bengaluru',4,'Hotel',
           'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80',
           'Valid photo ID required.',1
    UNION ALL
    SELECT 'Bengaluru','Koramangala Suites','koramangala-suites',
           'Spacious modern suites suited to longer business and leisure stays.',
           'Koramangala, Bengaluru',4,'Apartment',
           'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80',
           'Quiet hours after 10 PM.',0
    UNION ALL
    SELECT 'Bengaluru','Electronic City Grand','electronic-city-grand',
           'Business-friendly hotel with convenient access to Bengaluru technology parks.',
           'Electronic City, Bengaluru',5,'Hotel',
           'https://images.unsplash.com/photo-1549294413-26f195200c16?auto=format&fit=crop&w=1200&q=80',
           'Government ID required at check-in.',1

    UNION ALL
    SELECT 'Hyderabad','Jubilee Hills Residency','jubilee-hills-residency',
           'Elegant city stay with easy access to restaurants and entertainment.',
           'Jubilee Hills, Hyderabad',4,'Hotel',
           'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80',
           'Valid photo ID required.',1
    UNION ALL
    SELECT 'Hyderabad','Hitech City Suites','hitech-city-suites',
           'Modern suites for corporate travellers near Hyderabad technology districts.',
           'Hitech City, Hyderabad',4,'Apartment',
           'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80',
           'Standard house rules apply.',0
    UNION ALL
    SELECT 'Hyderabad','Charminar Grand','charminar-grand',
           'Comfortable hospitality inspired by Hyderabad heritage and culture.',
           'Abids, Hyderabad',4,'Hotel',
           'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
           'Government photo ID required.',0

    UNION ALL
    SELECT 'Chennai','T Nagar Residency','t-nagar-residency',
           'Convenient city hotel close to shopping and commercial districts.',
           'T Nagar, Chennai',4,'Hotel',
           'https://images.unsplash.com/photo-1568084680786-a84f91d1153c?auto=format&fit=crop&w=1200&q=80',
           'Valid photo ID required.',1
    UNION ALL
    SELECT 'Chennai','ECR Coastal Retreat','ecr-coastal-retreat',
           'Relaxed coastal retreat for weekend and family stays.',
           'East Coast Road, Chennai',4,'Resort',
           'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=80',
           'Resort rules apply. Quiet hours after 10 PM.',1
    UNION ALL
    SELECT 'Chennai','Guindy Business Hotel','guindy-business-hotel',
           'Professional business hotel with quick access to key commercial areas.',
           'Guindy, Chennai',4,'Hotel',
           'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80',
           'Standard cancellation policy applies.',0

    UNION ALL
    SELECT 'Pune','Koregaon Park Suites','koregaon-park-suites',
           'Premium suites near popular dining and leisure destinations.',
           'Koregaon Park, Pune',5,'Apartment',
           'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80',
           'Valid photo ID required.',1
    UNION ALL
    SELECT 'Pune','Baner Urban Hotel','baner-urban-hotel',
           'Smart contemporary rooms close to IT and business areas.',
           'Baner, Pune',4,'Hotel',
           'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80',
           'Standard hotel rules apply.',0
    UNION ALL
    SELECT 'Pune','Viman Nagar Residency','viman-nagar-residency',
           'Convenient airport-side stay for short and extended visits.',
           'Viman Nagar, Pune',4,'Hotel',
           'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80',
           'Government ID required.',0

    UNION ALL
    SELECT 'Jaipur','Amber Heritage Stay','amber-heritage-stay',
           'Heritage-inspired accommodation with warm Rajasthani hospitality.',
           'Amer Road, Jaipur',5,'Hotel',
           'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?auto=format&fit=crop&w=1200&q=80',
           'Valid government ID required.',1
    UNION ALL
    SELECT 'Jaipur','Jaipur Courtyard Hotel','jaipur-courtyard-hotel',
           'Comfortable hotel with traditional design and modern facilities.',
           'Bani Park, Jaipur',4,'Hotel',
           'https://images.unsplash.com/photo-1549294413-26f195200c16?auto=format&fit=crop&w=1200&q=80',
           'Standard cancellation rules apply.',0
    UNION ALL
    SELECT 'Jaipur','Hawa Mahal Residency','hawa-mahal-residency',
           'Central stay with convenient access to Jaipur heritage attractions.',
           'Johari Bazaar, Jaipur',4,'Hotel',
           'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
           'Photo ID required.',0

    UNION ALL
    SELECT 'Goa','Palm Coast Resort','palm-coast-resort',
           'Tropical resort with relaxed spaces for couples, friends and families.',
           'Baga, Goa',5,'Resort',
           'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=80',
           'Resort policies apply. No loud music after 10 PM.',1
    UNION ALL
    SELECT 'Goa','Anjuna Sunset Suites','anjuna-sunset-suites',
           'Boutique-style suites close to beaches and local attractions.',
           'Anjuna, Goa',4,'Apartment',
           'https://images.unsplash.com/photo-1559599238-308793637427?auto=format&fit=crop&w=1200&q=80',
           'Valid ID required at check-in.',1

    UNION ALL
    SELECT 'Dehradun','Mussoorie Road Haven','mussoorie-road-haven',
           'Peaceful hotel with convenient access to Dehradun and the hill route.',
           'Mussoorie Road, Dehradun',4,'Hotel',
           'https://images.unsplash.com/photo-1563911302283-d2bc129e7570?auto=format&fit=crop&w=1200&q=80',
           'Valid photo ID required.',1
    UNION ALL
    SELECT 'Dehradun','Forest View Residency','forest-view-residency-dehradun',
           'Quiet city stay with a relaxed atmosphere near green surroundings.',
           'Sahastradhara Road, Dehradun',4,'Hotel',
           'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80',
           'Standard house rules apply.',0
    UNION ALL
    SELECT 'Dehradun','Clock Tower Grand','clock-tower-grand-dehradun',
           'Central Dehradun hotel suited to business, family and short stays.',
           'Rajpur Road, Dehradun',3,'Hotel',
           'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80',
           'Government ID required.',0

    UNION ALL
    SELECT 'Durgapur','City Centre Grand Durgapur','city-centre-grand-durgapur',
           'Modern business hotel in the heart of Durgapur City Centre.',
           'City Centre, Durgapur',4,'Hotel',
           'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80',
           'Photo ID required at check-in.',1
    UNION ALL
    SELECT 'Durgapur','Benachity Residency','benachity-residency',
           'Affordable and comfortable accommodation close to local shopping areas.',
           'Benachity, Durgapur',3,'Hotel',
           'https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=1200&q=80',
           'Standard hotel rules apply.',0
    UNION ALL
    SELECT 'Durgapur','Durgapur Business Suites','durgapur-business-suites',
           'Business-oriented rooms and suites for corporate travellers.',
           'Bidhannagar, Durgapur',4,'Apartment',
           'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80',
           'Valid government ID required.',0

    UNION ALL
    SELECT 'Asansol','Burnpur Residency','burnpur-residency',
           'Comfortable stay for business and family travellers in Asansol.',
           'Burnpur Road, Asansol',3,'Hotel',
           'https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=1200&q=80',
           'Photo ID required.',0
    UNION ALL
    SELECT 'Asansol','Galaxy Mall Suites','galaxy-mall-suites',
           'Modern suites near shopping, dining and entertainment areas.',
           'Burnpur Road, Asansol',4,'Apartment',
           'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80',
           'Standard house rules apply.',1
    UNION ALL
    SELECT 'Asansol','Asansol Business Inn','asansol-business-inn',
           'Practical business hotel with comfortable rooms and city access.',
           'GT Road, Asansol',4,'Hotel',
           'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80',
           'Government ID required.',0
) AS x
JOIN cities c
    ON c.name = x.city_name
WHERE NOT EXISTS (
    SELECT 1
    FROM hotels h
    WHERE h.slug = x.slug
);

-- ---------------------------------------------------------
-- Add 3 room types to the newly added hotels
-- ---------------------------------------------------------

INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id, 'Standard Room', 'Queen Bed', '260 sq ft', 2, 8,
    CASE
        WHEN h.star_rating = 5 THEN 3200
        WHEN h.star_rating = 4 THEN 2500
        ELSE 1800
    END,
    5,
    'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN (
'connaught-crown-hotel','aerocity-horizon',
'harbour-lights-mumbai','bandra-skyline-hotel',
'park-street-residency','salt-lake-grand',
'indiranagar-urban-stay','koramangala-suites','electronic-city-grand',
'jubilee-hills-residency','hitech-city-suites','charminar-grand',
't-nagar-residency','ecr-coastal-retreat','guindy-business-hotel',
'koregaon-park-suites','baner-urban-hotel','viman-nagar-residency',
'amber-heritage-stay','jaipur-courtyard-hotel','hawa-mahal-residency',
'palm-coast-resort','anjuna-sunset-suites',
'mussoorie-road-haven','forest-view-residency-dehradun','clock-tower-grand-dehradun',
'city-centre-grand-durgapur','benachity-residency','durgapur-business-suites',
'burnpur-residency','galaxy-mall-suites','asansol-business-inn'
)
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Standard Room'
);

INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id, 'Deluxe Room', 'King Bed', '340 sq ft', 3, 5,
    CASE
        WHEN h.star_rating = 5 THEN 4800
        WHEN h.star_rating = 4 THEN 3900
        ELSE 2900
    END,
    10,
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN (
'connaught-crown-hotel','aerocity-horizon',
'harbour-lights-mumbai','bandra-skyline-hotel',
'park-street-residency','salt-lake-grand',
'indiranagar-urban-stay','koramangala-suites','electronic-city-grand',
'jubilee-hills-residency','hitech-city-suites','charminar-grand',
't-nagar-residency','ecr-coastal-retreat','guindy-business-hotel',
'koregaon-park-suites','baner-urban-hotel','viman-nagar-residency',
'amber-heritage-stay','jaipur-courtyard-hotel','hawa-mahal-residency',
'palm-coast-resort','anjuna-sunset-suites',
'mussoorie-road-haven','forest-view-residency-dehradun','clock-tower-grand-dehradun',
'city-centre-grand-durgapur','benachity-residency','durgapur-business-suites',
'burnpur-residency','galaxy-mall-suites','asansol-business-inn'
)
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Deluxe Room'
);

INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id, 'Suite', 'King Bed', '520 sq ft', 4, 2,
    CASE
        WHEN h.star_rating = 5 THEN 7600
        WHEN h.star_rating = 4 THEN 6200
        ELSE 4700
    END,
    8,
    'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN (
'connaught-crown-hotel','aerocity-horizon',
'harbour-lights-mumbai','bandra-skyline-hotel',
'park-street-residency','salt-lake-grand',
'indiranagar-urban-stay','koramangala-suites','electronic-city-grand',
'jubilee-hills-residency','hitech-city-suites','charminar-grand',
't-nagar-residency','ecr-coastal-retreat','guindy-business-hotel',
'koregaon-park-suites','baner-urban-hotel','viman-nagar-residency',
'amber-heritage-stay','jaipur-courtyard-hotel','hawa-mahal-residency',
'palm-coast-resort','anjuna-sunset-suites',
'mussoorie-road-haven','forest-view-residency-dehradun','clock-tower-grand-dehradun',
'city-centre-grand-durgapur','benachity-residency','durgapur-business-suites',
'burnpur-residency','galaxy-mall-suites','asansol-business-inn'
)
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Suite'
);

-- ---------------------------------------------------------
-- Add two gallery images per newly added hotel
-- ---------------------------------------------------------

INSERT INTO hotel_images (hotel_id, image_url)
SELECT h.id,
       'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1000&q=80'
FROM hotels h
WHERE h.slug IN (
'connaught-crown-hotel','aerocity-horizon',
'harbour-lights-mumbai','bandra-skyline-hotel',
'park-street-residency','salt-lake-grand',
'indiranagar-urban-stay','koramangala-suites','electronic-city-grand',
'jubilee-hills-residency','hitech-city-suites','charminar-grand',
't-nagar-residency','ecr-coastal-retreat','guindy-business-hotel',
'koregaon-park-suites','baner-urban-hotel','viman-nagar-residency',
'amber-heritage-stay','jaipur-courtyard-hotel','hawa-mahal-residency',
'palm-coast-resort','anjuna-sunset-suites',
'mussoorie-road-haven','forest-view-residency-dehradun','clock-tower-grand-dehradun',
'city-centre-grand-durgapur','benachity-residency','durgapur-business-suites',
'burnpur-residency','galaxy-mall-suites','asansol-business-inn'
)
AND NOT EXISTS (
    SELECT 1 FROM hotel_images hi
    WHERE hi.hotel_id = h.id
      AND hi.image_url = 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1000&q=80'
);

INSERT INTO hotel_images (hotel_id, image_url)
SELECT h.id,
       'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1000&q=80'
FROM hotels h
WHERE h.slug IN (
'connaught-crown-hotel','aerocity-horizon',
'harbour-lights-mumbai','bandra-skyline-hotel',
'park-street-residency','salt-lake-grand',
'indiranagar-urban-stay','koramangala-suites','electronic-city-grand',
'jubilee-hills-residency','hitech-city-suites','charminar-grand',
't-nagar-residency','ecr-coastal-retreat','guindy-business-hotel',
'koregaon-park-suites','baner-urban-hotel','viman-nagar-residency',
'amber-heritage-stay','jaipur-courtyard-hotel','hawa-mahal-residency',
'palm-coast-resort','anjuna-sunset-suites',
'mussoorie-road-haven','forest-view-residency-dehradun','clock-tower-grand-dehradun',
'city-centre-grand-durgapur','benachity-residency','durgapur-business-suites',
'burnpur-residency','galaxy-mall-suites','asansol-business-inn'
)
AND NOT EXISTS (
    SELECT 1 FROM hotel_images hi
    WHERE hi.hotel_id = h.id
      AND hi.image_url = 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1000&q=80'
);

-- ---------------------------------------------------------
-- Give the new hotels standard amenities
-- ---------------------------------------------------------

INSERT IGNORE INTO hotel_amenities (hotel_id, amenity_id)
SELECT h.id, a.id
FROM hotels h
CROSS JOIN amenities a
WHERE h.slug IN (
'connaught-crown-hotel','aerocity-horizon',
'harbour-lights-mumbai','bandra-skyline-hotel',
'park-street-residency','salt-lake-grand',
'indiranagar-urban-stay','koramangala-suites','electronic-city-grand',
'jubilee-hills-residency','hitech-city-suites','charminar-grand',
't-nagar-residency','ecr-coastal-retreat','guindy-business-hotel',
'koregaon-park-suites','baner-urban-hotel','viman-nagar-residency',
'amber-heritage-stay','jaipur-courtyard-hotel','hawa-mahal-residency',
'palm-coast-resort','anjuna-sunset-suites',
'mussoorie-road-haven','forest-view-residency-dehradun','clock-tower-grand-dehradun',
'city-centre-grand-durgapur','benachity-residency','durgapur-business-suites',
'burnpur-residency','galaxy-mall-suites','asansol-business-inn'
)
AND a.name IN ('Wi-Fi','Parking','Restaurant','AC','Room Service','Breakfast');

-- ---------------------------------------------------------
-- Verification: should show 4 hotels in each city
-- ---------------------------------------------------------

SELECT
    c.name AS city,
    COUNT(h.id) AS hotel_count
FROM cities c
LEFT JOIN hotels h
    ON h.city_id = c.id
   AND h.status = 'active'
GROUP BY c.id, c.name
ORDER BY c.name;

SELECT COUNT(*) AS total_hotels
FROM hotels
WHERE status = 'active';
