USE staysphere;

-- =========================================================
-- StaySphere expansion: add 6 additional hotels per city.
-- Run this AFTER the earlier 4-hotels-per-city data.
-- Result: 10 hotels per city, 120 hotels total.
-- This script is safe to re-run because hotel slugs are unique.
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
    SELECT 'Delhi' city_name, 'Karol Bagh Central' name, 'karol-bagh-central' slug, 'Comfortable city hotel close to markets, metro access and central Delhi attractions.' description, 'Karol Bagh, New Delhi' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Delhi' city_name, 'Saket Select Stay' name, 'saket-select-stay' slug, 'Modern hotel near shopping malls, business hubs and South Delhi dining.' description, 'Saket, New Delhi' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Delhi' city_name, 'Dwarka Premier' name, 'dwarka-premier' slug, 'Spacious rooms and convenient access to the airport and Dwarka business district.' description, 'Dwarka, New Delhi' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Delhi' city_name, 'Lajpat Nagar Residency' name, 'lajpat-nagar-residency' slug, 'Affordable modern accommodation near markets and public transport.' description, 'Lajpat Nagar, New Delhi' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Delhi' city_name, 'South Delhi Suites' name, 'south-delhi-suites' slug, 'Premium suites for business and family stays in South Delhi.' description, 'Greater Kailash, New Delhi' address, 5 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Delhi' city_name, 'Red Fort Heritage Inn' name, 'red-fort-heritage-inn' slug, 'Heritage-inspired stay with easy access to Old Delhi landmarks.' description, 'Chandni Chowk, New Delhi' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Mumbai' city_name, 'Juhu Beach Grand' name, 'juhu-beach-grand' slug, 'Premium stay near Juhu Beach with modern rooms and leisure facilities.' description, 'Juhu, Mumbai' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Mumbai' city_name, 'Andheri Metro Stay' name, 'andheri-metro-stay' slug, 'Convenient hotel for airport, metro and business district access.' description, 'Andheri East, Mumbai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Mumbai' city_name, 'Powai Lake Suites' name, 'powai-lake-suites' slug, 'Contemporary suites close to Powai Lake and major technology offices.' description, 'Powai, Mumbai' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Mumbai' city_name, 'Marine Drive Residency' name, 'marine-drive-residency' slug, 'Central Mumbai accommodation near the waterfront and city attractions.' description, 'Marine Drive, Mumbai' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Mumbai' city_name, 'Navi Mumbai Business Inn' name, 'navi-mumbai-business-inn' slug, 'Business-focused hotel with comfortable rooms and fast city access.' description, 'Vashi, Navi Mumbai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Mumbai' city_name, 'Lower Parel Urban Hotel' name, 'lower-parel-urban-hotel' slug, 'Stylish urban hotel near offices, malls and entertainment.' description, 'Lower Parel, Mumbai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Kolkata' city_name, 'New Town Premier' name, 'new-town-premier-kolkata' slug, 'Modern hotel serving business travellers near New Town and IT hubs.' description, 'New Town, Kolkata' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Kolkata' city_name, 'Howrah Riverside Inn' name, 'howrah-riverside-inn' slug, 'Comfortable stay with convenient access to Howrah and central Kolkata.' description, 'Howrah, Kolkata' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Kolkata' city_name, 'Ballygunge Boutique Stay' name, 'ballygunge-boutique-stay' slug, 'Boutique-style rooms in a popular South Kolkata neighbourhood.' description, 'Ballygunge, Kolkata' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Kolkata' city_name, 'Esplanade City Hotel' name, 'esplanade-city-hotel' slug, 'Central location for shopping, transit and Kolkata attractions.' description, 'Esplanade, Kolkata' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Kolkata' city_name, 'Rajarhat Business Suites' name, 'rajarhat-business-suites' slug, 'Spacious suites for corporate guests near airport-side business areas.' description, 'Rajarhat, Kolkata' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Kolkata' city_name, 'Victoria Heritage Residency' name, 'victoria-heritage-residency' slug, 'Elegant stay inspired by Kolkata heritage close to major landmarks.' description, 'Chowringhee, Kolkata' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Bengaluru' city_name, 'Whitefield Executive Stay' name, 'whitefield-executive-stay' slug, 'Business-friendly hotel near major technology parks in Whitefield.' description, 'Whitefield, Bengaluru' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Bengaluru' city_name, 'MG Road Grand' name, 'mg-road-grand-bengaluru' slug, 'Premium city hotel close to shopping, dining and business destinations.' description, 'MG Road, Bengaluru' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Bengaluru' city_name, 'Hebbal Airport Suites' name, 'hebbal-airport-suites' slug, 'Convenient suites for travellers moving between the airport and city.' description, 'Hebbal, Bengaluru' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Bengaluru' city_name, 'Jayanagar Comfort Inn' name, 'jayanagar-comfort-inn' slug, 'Quiet, comfortable hotel in a well-connected residential district.' description, 'Jayanagar, Bengaluru' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Bengaluru' city_name, 'Brigade Road Boutique' name, 'brigade-road-boutique' slug, 'Stylish boutique hotel near Bengaluru nightlife and shopping.' description, 'Brigade Road, Bengaluru' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Bengaluru' city_name, 'Manyata Tech Residency' name, 'manyata-tech-residency' slug, 'Modern corporate stay near Manyata Tech Park.' description, 'Nagawara, Bengaluru' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Hyderabad' city_name, 'Banjara Hills Grand' name, 'banjara-hills-grand' slug, 'Upscale hotel in one of Hyderabad''s prime neighbourhoods.' description, 'Banjara Hills, Hyderabad' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Hyderabad' city_name, 'Gachibowli Executive Inn' name, 'gachibowli-executive-inn' slug, 'Business hotel near financial and technology districts.' description, 'Gachibowli, Hyderabad' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Hyderabad' city_name, 'Secunderabad Central Stay' name, 'secunderabad-central-stay' slug, 'Convenient city hotel near transport, shopping and business areas.' description, 'Secunderabad, Hyderabad' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Hyderabad' city_name, 'Madhapur Urban Suites' name, 'madhapur-urban-suites' slug, 'Contemporary suites for corporate and extended stays.' description, 'Madhapur, Hyderabad' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Hyderabad' city_name, 'Hussain Sagar View Hotel' name, 'hussain-sagar-view-hotel' slug, 'Comfortable premium stay near the lake and central attractions.' description, 'Tank Bund, Hyderabad' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Hyderabad' city_name, 'Begumpet Residency' name, 'begumpet-residency' slug, 'Well-connected hotel suited to business and family travel.' description, 'Begumpet, Hyderabad' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Chennai' city_name, 'Anna Nagar Grand' name, 'anna-nagar-grand' slug, 'Modern city hotel in a popular residential and shopping district.' description, 'Anna Nagar, Chennai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Chennai' city_name, 'OMR Tech Stay' name, 'omr-tech-stay' slug, 'Business-focused accommodation near Chennai''s IT corridor.' description, 'OMR, Chennai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Chennai' city_name, 'Mylapore Heritage Inn' name, 'mylapore-heritage-inn' slug, 'Heritage-inspired hotel near cultural and religious attractions.' description, 'Mylapore, Chennai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Chennai' city_name, 'Velachery Urban Suites' name, 'velachery-urban-suites' slug, 'Comfortable suites close to shopping malls and business hubs.' description, 'Velachery, Chennai' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Chennai' city_name, 'Nungambakkam Premier' name, 'nungambakkam-premier' slug, 'Premium stay with central access to dining and entertainment.' description, 'Nungambakkam, Chennai' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Chennai' city_name, 'Besant Nagar Beach Stay' name, 'besant-nagar-beach-stay' slug, 'Relaxed hotel near the beach, cafés and coastal attractions.' description, 'Besant Nagar, Chennai' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Pune' city_name, 'Hinjewadi Tech Hotel' name, 'hinjewadi-tech-hotel' slug, 'Modern corporate stay near Pune''s major IT parks.' description, 'Hinjewadi, Pune' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Pune' city_name, 'Shivajinagar Central Inn' name, 'shivajinagar-central-inn' slug, 'Convenient central Pune hotel with transport access.' description, 'Shivajinagar, Pune' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Pune' city_name, 'Kharadi Business Suites' name, 'kharadi-business-suites' slug, 'Spacious business suites close to office campuses.' description, 'Kharadi, Pune' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Pune' city_name, 'Camp Heritage Hotel' name, 'camp-heritage-hotel-pune' slug, 'Classic city stay close to Pune Camp and shopping districts.' description, 'Camp, Pune' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Pune' city_name, 'Aundh Premier Stay' name, 'aundh-premier-stay' slug, 'Modern accommodation near cafés, offices and residential areas.' description, 'Aundh, Pune' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Pune' city_name, 'Magarpatta Grand' name, 'magarpatta-grand' slug, 'Premium business hotel near Magarpatta City.' description, 'Hadapsar, Pune' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Jaipur' city_name, 'C Scheme Premier' name, 'c-scheme-premier-jaipur' slug, 'Modern premium hotel in central Jaipur with convenient city access.' description, 'C Scheme, Jaipur' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Jaipur' city_name, 'Vaishali Nagar Stay' name, 'vaishali-nagar-stay' slug, 'Comfortable accommodation near restaurants, shopping and residential areas.' description, 'Vaishali Nagar, Jaipur' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Jaipur' city_name, 'Mansarovar Urban Inn' name, 'mansarovar-urban-inn' slug, 'Affordable city hotel with metro and road connectivity.' description, 'Mansarovar, Jaipur' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Jaipur' city_name, 'Nahargarh View Hotel' name, 'nahargarh-view-hotel' slug, 'Heritage-inspired stay with easy access to Jaipur sightseeing.' description, 'Nahargarh Road, Jaipur' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Jaipur' city_name, 'Malviya Nagar Suites' name, 'malviya-nagar-suites-jaipur' slug, 'Contemporary suites close to shopping and airport access.' description, 'Malviya Nagar, Jaipur' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Jaipur' city_name, 'Royal Rajputana Resort' name, 'royal-rajputana-resort' slug, 'Elegant resort-style experience inspired by Rajasthan hospitality.' description, 'Ajmer Road, Jaipur' address, 5 star_rating, 'Resort' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Goa' city_name, 'Calangute Beach Grand' name, 'calangute-beach-grand' slug, 'Lively beach-area hotel for leisure travellers and groups.' description, 'Calangute, Goa' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Goa' city_name, 'Candolim Coastal Resort' name, 'candolim-coastal-resort' slug, 'Relaxed coastal resort close to the beach and restaurants.' description, 'Candolim, Goa' address, 5 star_rating, 'Resort' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Goa' city_name, 'Panaji Riverside Stay' name, 'panaji-riverside-stay' slug, 'Comfortable city stay with easy access to Panaji attractions.' description, 'Panaji, Goa' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Goa' city_name, 'Vagator Cliff Suites' name, 'vagator-cliff-suites' slug, 'Boutique suites near scenic coastal areas and nightlife.' description, 'Vagator, Goa' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Goa' city_name, 'South Goa Serenity Resort' name, 'south-goa-serenity-resort' slug, 'Peaceful resort designed for relaxing family and couple stays.' description, 'Colva, Goa' address, 5 star_rating, 'Resort' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Goa' city_name, 'Morjim Palm Stay' name, 'morjim-palm-stay' slug, 'Casual beach accommodation near Morjim''s quieter coastal stretch.' description, 'Morjim, Goa' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Dehradun' city_name, 'Rajpur Heights Hotel' name, 'rajpur-heights-hotel' slug, 'Premium stay along Rajpur Road with easy access to cafés and city attractions.' description, 'Rajpur Road, Dehradun' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Dehradun' city_name, 'Sahastradhara Valley Resort' name, 'sahastradhara-valley-resort' slug, 'Relaxed resort-style stay near the Sahastradhara area.' description, 'Sahastradhara, Dehradun' address, 4 star_rating, 'Resort' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Dehradun' city_name, 'ISBT Comfort Inn' name, 'isbt-comfort-inn-dehradun' slug, 'Affordable and convenient hotel near major transport connections.' description, 'ISBT, Dehradun' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Dehradun' city_name, 'Pacific Hills Residency' name, 'pacific-hills-residency' slug, 'Modern hotel near shopping and residential areas.' description, 'Jakhan, Dehradun' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Dehradun' city_name, 'Doon Executive Suites' name, 'doon-executive-suites' slug, 'Spacious suites suitable for business, families and extended stays.' description, 'Ballupur, Dehradun' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Dehradun' city_name, 'Forest Research Stay' name, 'forest-research-stay' slug, 'Peaceful accommodation with convenient access to western Dehradun.' description, 'Kaulagarh Road, Dehradun' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Durgapur' city_name, 'Bidhannagar Grand' name, 'bidhannagar-grand-durgapur' slug, 'Modern hotel for business and family stays in Bidhannagar.' description, 'Bidhannagar, Durgapur' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Durgapur' city_name, 'Junction Comfort Hotel' name, 'junction-comfort-hotel-durgapur' slug, 'Convenient hotel for travellers near transport links and city services.' description, 'Durgapur Station Area, Durgapur' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Durgapur' city_name, 'Muchipara Urban Stay' name, 'muchipara-urban-stay' slug, 'Affordable modern rooms with easy access to the city.' description, 'Muchipara, Durgapur' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Durgapur' city_name, 'City Centre Executive Suites' name, 'city-centre-executive-suites-durgapur' slug, 'Corporate-friendly suites near City Centre offices and shopping.' description, 'City Centre, Durgapur' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Durgapur' city_name, 'Benachity Grand Hotel' name, 'benachity-grand-hotel' slug, 'Comfortable hotel near Benachity market and local conveniences.' description, 'Benachity, Durgapur' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Durgapur' city_name, 'Durgapur Steel City Inn' name, 'durgapur-steel-city-inn' slug, 'Practical hotel for industrial, corporate and short-stay travellers.' description, 'A-Zone, Durgapur' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Asansol' city_name, 'GT Road Grand' name, 'gt-road-grand-asansol' slug, 'Modern hotel on a major Asansol corridor with convenient city access.' description, 'GT Road, Asansol' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Asansol' city_name, 'Ushagram Residency' name, 'ushagram-residency' slug, 'Comfortable accommodation in a well-connected Asansol neighbourhood.' description, 'Ushagram, Asansol' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Asansol' city_name, 'Asansol Junction Inn' name, 'asansol-junction-inn' slug, 'Convenient budget-friendly hotel for rail and city travellers.' description, 'Station Road, Asansol' address, 3 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 1 featured UNION ALL
    SELECT 'Asansol' city_name, 'Chelidanga Urban Hotel' name, 'chelidanga-urban-hotel' slug, 'Modern city rooms close to shopping and local services.' description, 'Chelidanga, Asansol' address, 4 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Asansol' city_name, 'Burnpur Executive Suites' name, 'burnpur-executive-suites' slug, 'Business-oriented suites for corporate and extended stays.' description, 'Burnpur, Asansol' address, 4 star_rating, 'Apartment' property_type, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured UNION ALL
    SELECT 'Asansol' city_name, 'Asansol Premier Hotel' name, 'asansol-premier-hotel' slug, 'Premium city hotel for family, business and leisure guests.' description, 'Court More, Asansol' address, 5 star_rating, 'Hotel' property_type, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80' cover_image, 'Valid government photo ID required at check-in. Standard cancellation and hotel rules apply.' policies, 0 featured
) AS x
JOIN cities c ON c.name = x.city_name
WHERE NOT EXISTS (
    SELECT 1
    FROM hotels h
    WHERE h.slug = x.slug
);

-- Add Standard Room
INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id,
    'Standard Room',
    'Queen Bed',
    '260 sq ft',
    2,
    8,
    CASE
        WHEN h.star_rating = 5 THEN 3400
        WHEN h.star_rating = 4 THEN 2600
        ELSE 1900
    END,
    5,
    'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Standard Room'
);

-- Add Deluxe Room
INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id,
    'Deluxe Room',
    'King Bed',
    '350 sq ft',
    3,
    6,
    CASE
        WHEN h.star_rating = 5 THEN 5000
        WHEN h.star_rating = 4 THEN 4000
        ELSE 3000
    END,
    10,
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Deluxe Room'
);

-- Add Executive Room
INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id,
    'Executive Room',
    'King Bed',
    '420 sq ft',
    3,
    4,
    CASE
        WHEN h.star_rating = 5 THEN 6200
        WHEN h.star_rating = 4 THEN 5000
        ELSE 3900
    END,
    8,
    'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Executive Room'
);

-- Add Suite
INSERT INTO rooms
(hotel_id, room_type, bed_type, room_size, max_guests, total_rooms, price, discount_percentage, image_url)
SELECT
    h.id,
    'Suite',
    'King Bed',
    '540 sq ft',
    4,
    3,
    CASE
        WHEN h.star_rating = 5 THEN 8200
        WHEN h.star_rating = 4 THEN 6500
        ELSE 4900
    END,
    12,
    'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=900&q=80'
FROM hotels h
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND NOT EXISTS (
    SELECT 1 FROM rooms r
    WHERE r.hotel_id = h.id AND r.room_type = 'Suite'
);

-- Two gallery images per new hotel
INSERT INTO hotel_images (hotel_id, image_url)
SELECT
    h.id,
    'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1000&q=80'
FROM hotels h
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND NOT EXISTS (
    SELECT 1 FROM hotel_images hi
    WHERE hi.hotel_id = h.id
      AND hi.image_url = 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1000&q=80'
);

INSERT INTO hotel_images (hotel_id, image_url)
SELECT
    h.id,
    'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1000&q=80'
FROM hotels h
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND NOT EXISTS (
    SELECT 1 FROM hotel_images hi
    WHERE hi.hotel_id = h.id
      AND hi.image_url = 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1000&q=80'
);

-- Attach common amenities to the new hotels
INSERT IGNORE INTO hotel_amenities (hotel_id, amenity_id)
SELECT
    h.id,
    a.id
FROM hotels h
CROSS JOIN amenities a
WHERE h.slug IN ('karol-bagh-central','saket-select-stay','dwarka-premier','lajpat-nagar-residency','south-delhi-suites','red-fort-heritage-inn','juhu-beach-grand','andheri-metro-stay','powai-lake-suites','marine-drive-residency','navi-mumbai-business-inn','lower-parel-urban-hotel','new-town-premier-kolkata','howrah-riverside-inn','ballygunge-boutique-stay','esplanade-city-hotel','rajarhat-business-suites','victoria-heritage-residency','whitefield-executive-stay','mg-road-grand-bengaluru','hebbal-airport-suites','jayanagar-comfort-inn','brigade-road-boutique','manyata-tech-residency','banjara-hills-grand','gachibowli-executive-inn','secunderabad-central-stay','madhapur-urban-suites','hussain-sagar-view-hotel','begumpet-residency','anna-nagar-grand','omr-tech-stay','mylapore-heritage-inn','velachery-urban-suites','nungambakkam-premier','besant-nagar-beach-stay','hinjewadi-tech-hotel','shivajinagar-central-inn','kharadi-business-suites','camp-heritage-hotel-pune','aundh-premier-stay','magarpatta-grand','c-scheme-premier-jaipur','vaishali-nagar-stay','mansarovar-urban-inn','nahargarh-view-hotel','malviya-nagar-suites-jaipur','royal-rajputana-resort','calangute-beach-grand','candolim-coastal-resort','panaji-riverside-stay','vagator-cliff-suites','south-goa-serenity-resort','morjim-palm-stay','rajpur-heights-hotel','sahastradhara-valley-resort','isbt-comfort-inn-dehradun','pacific-hills-residency','doon-executive-suites','forest-research-stay','bidhannagar-grand-durgapur','junction-comfort-hotel-durgapur','muchipara-urban-stay','city-centre-executive-suites-durgapur','benachity-grand-hotel','durgapur-steel-city-inn','gt-road-grand-asansol','ushagram-residency','asansol-junction-inn','chelidanga-urban-hotel','burnpur-executive-suites','asansol-premier-hotel')
AND a.name IN (
    'Wi-Fi',
    'Parking',
    'Restaurant',
    'AC',
    'Room Service',
    'Breakfast'
);

-- Verification
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
