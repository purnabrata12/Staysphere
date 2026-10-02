USE staysphere;
INSERT INTO admins(name,email,password_hash) VALUES ('StaySphere Admin','admin@staysphere.com','$2y$12$zNF3BGgXOYd5HrQEismMgOxlRQiGNLAAz/..bS/e9BjCmI85HxkUu');
INSERT INTO users(full_name,email,phone,password_hash,address) VALUES ('Demo Customer','demo@staysphere.com','9999999999','$2y$12$9uFzwj93JkeQB2Qiu7YK7ea1lqtdlBq6yH6LwhOFzgEHqtrC6Iaya','India');
INSERT INTO cities(name,state,description,image) VALUES
('Delhi','Delhi','Historic capital with business and leisure stays.','https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=1200&q=80'),
('Mumbai','Maharashtra','Coastal city known for business, culture and nightlife.','https://images.unsplash.com/photo-1595658658481-d53d3f999875?auto=format&fit=crop&w=1200&q=80'),
('Kolkata','West Bengal','Culture, heritage and warm hospitality.','https://images.unsplash.com/photo-1558431382-27e303142255?auto=format&fit=crop&w=1200&q=80'),
('Bengaluru','Karnataka','India’s technology capital with modern stays.','https://images.unsplash.com/photo-1596176530529-78163a4f7af2?auto=format&fit=crop&w=1200&q=80'),
('Hyderabad','Telangana','Heritage, cuisine and technology hubs.','https://images.unsplash.com/photo-1573445329481-f907a124ed9b?auto=format&fit=crop&w=1200&q=80'),
('Chennai','Tamil Nadu','Coastal city with culture and business hotels.','https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80'),
('Pune','Maharashtra','Education, IT and relaxed city stays.','https://images.unsplash.com/photo-1606768666853-403c90a981ad?auto=format&fit=crop&w=1200&q=80'),
('Jaipur','Rajasthan','Royal heritage and colourful hospitality.','https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=1200&q=80'),
('Goa','Goa','Beach resorts, villas and weekend escapes.','https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=1200&q=80'),
('Dehradun','Uttarakhand','Gateway to the hills with peaceful stays.','https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=1200&q=80'),
('Durgapur','West Bengal','Industrial city with comfortable business hotels.','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80'),
('Asansol','West Bengal','Commercial city with convenient stays.','https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80');
INSERT INTO amenities(name) VALUES ('Wi-Fi'),('Parking'),('Restaurant'),('Swimming Pool'),('Gym'),('Spa'),('Breakfast'),('Room Service'),('AC'),('Airport Shuttle');
INSERT INTO hotels(city_id,name,slug,description,address,star_rating,property_type,cover_image,policies,featured) VALUES
(1,'Capital Grand','capital-grand','Premium city hotel near major attractions.','Connaught Place, New Delhi',5,'Hotel','https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80','Government photo ID required at check-in.',1),
(1,'Imperial Stay Delhi','imperial-stay-delhi','Elegant rooms for business and leisure travel.','Karol Bagh, New Delhi',4,'Hotel','https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80','Standard cancellation policy applies.',1),
(2,'Sea View Residency','sea-view-residency','Modern stay with coastal city views.','Marine Drive, Mumbai',4,'Hotel','https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?auto=format&fit=crop&w=1200&q=80','Valid ID required.',1),
(2,'Mumbai Grand','mumbai-grand','Luxury business hotel in the heart of Mumbai.','Bandra, Mumbai',5,'Hotel','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80','No smoking in rooms.',1),
(3,'Grand Palace Kolkata','grand-palace-kolkata','Classic hospitality with modern amenities.','Park Street, Kolkata',4,'Hotel','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80','Photo ID required.',1),
(3,'Royal Bengal Stay','royal-bengal-stay','Comfortable city stay close to shopping and dining.','Salt Lake, Kolkata',4,'Hotel','https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80','Standard house rules apply.',0),
(4,'Tech Park Suites','tech-park-suites','Smart modern suites for business travellers.','Whitefield, Bengaluru',4,'Apartment','https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80','Quiet hours after 10 PM.',1),
(5,'Nizam Heritage Hotel','nizam-heritage-hotel','Heritage-inspired interiors and contemporary comfort.','Banjara Hills, Hyderabad',5,'Hotel','https://images.unsplash.com/photo-1549294413-26f195200c16?auto=format&fit=crop&w=1200&q=80','Valid photo ID required.',1),
(6,'Marina Bay Chennai','marina-bay-chennai','Relaxed coastal hospitality near the city centre.','Mylapore, Chennai',4,'Hotel','https://images.unsplash.com/photo-1568084680786-a84f91d1153c?auto=format&fit=crop&w=1200&q=80','Standard cancellation rules apply.',0),
(7,'Pune Urban Nest','pune-urban-nest','Contemporary rooms near technology and education hubs.','Hinjewadi, Pune',4,'Hotel','https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80','Photo ID required.',0),
(8,'Pink City Palace','pink-city-palace','Royal-style hotel experience in Jaipur.','C-Scheme, Jaipur',5,'Hotel','https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?auto=format&fit=crop&w=1200&q=80','Government ID required.',1),
(9,'Beach Paradise Resort','beach-paradise-resort','Resort-style stay close to the beach.','Calangute, Goa',5,'Resort','https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=80','Resort rules apply.',1),
(9,'Ocean Breeze Goa','ocean-breeze-goa','Laid-back stay with pool and tropical ambience.','Candolim, Goa',4,'Resort','https://images.unsplash.com/photo-1559599238-308793637427?auto=format&fit=crop&w=1200&q=80','No outside music after 10 PM.',1),
(10,'Doon Valley Retreat','doon-valley-retreat','Peaceful stay with easy access to Dehradun city.','Rajpur Road, Dehradun',4,'Hotel','https://images.unsplash.com/photo-1563911302283-d2bc129e7570?auto=format&fit=crop&w=1200&q=80','Valid ID required.',1),
(11,'Durgapur City Inn','durgapur-city-inn','Clean and comfortable hotel for business travellers.','City Centre, Durgapur',3,'Hotel','https://images.unsplash.com/photo-1559599189-fe84dea4eb79?auto=format&fit=crop&w=1200&q=80','Standard house rules.',0),
(12,'Asansol Central Hotel','asansol-central-hotel','Convenient hotel close to commercial areas.','GT Road, Asansol',3,'Hotel','https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=1200&q=80','Photo ID required.',0);
INSERT INTO rooms(hotel_id,room_type,bed_type,room_size,max_guests,total_rooms,price,discount_percentage,image_url)
SELECT id,'Standard Room','Queen Bed','260 sq ft',2,8,2200,5,'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=900&q=80' FROM hotels;
INSERT INTO rooms(hotel_id,room_type,bed_type,room_size,max_guests,total_rooms,price,discount_percentage,image_url)
SELECT id,'Deluxe Room','King Bed','340 sq ft',3,5,3600,10,'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=900&q=80' FROM hotels;
INSERT INTO rooms(hotel_id,room_type,bed_type,room_size,max_guests,total_rooms,price,discount_percentage,image_url)
SELECT id,'Suite','King Bed','520 sq ft',4,2,6200,8,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=900&q=80' FROM hotels;
INSERT INTO hotel_images(hotel_id,image_url) SELECT id,'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1000&q=80' FROM hotels;
INSERT INTO hotel_images(hotel_id,image_url) SELECT id,'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1000&q=80' FROM hotels;
INSERT INTO hotel_amenities(hotel_id,amenity_id) SELECT h.id,a.id FROM hotels h CROSS JOIN amenities a WHERE a.name IN ('Wi-Fi','Parking','Restaurant','AC','Room Service');
INSERT INTO advertisements(title,description,promotional_link,start_date,end_date) VALUES ('Weekend Escape — Save up to 20%','Book selected stays across India and enjoy special demo pricing.','/offers','2026-01-01','2027-12-31');
