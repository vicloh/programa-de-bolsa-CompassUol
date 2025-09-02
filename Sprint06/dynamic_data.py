import random
from datetime import datetime, timedelta

def get_random_booking_data():
    firstnames = ["João", "Maria", "Pedro", "Ana", "Carlos", "Lucia", "Rafael", "Fernanda"]
    lastnames = ["Silva", "Santos", "Oliveira", "Souza", "Costa", "Pereira", "Almeida", "Ferreira"]
    
    checkin_date = datetime.now() + timedelta(days=random.randint(1, 30))
    checkout_date = checkin_date + timedelta(days=random.randint(1, 14))
    
    return {
        "firstname": random.choice(firstnames),
        "lastname": random.choice(lastnames),
        "totalprice": random.randint(100, 5000),
        "depositpaid": random.choice([True, False]),
        "bookingdates": {
            "checkin": checkin_date.strftime("%Y-%m-%d"),
            "checkout": checkout_date.strftime("%Y-%m-%d")
        }
    }