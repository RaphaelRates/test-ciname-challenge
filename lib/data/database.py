from robot.api.deco import keyword
from pymongo import MongoClient
import bcrypt

client = MongoClient('mongodb+srv://raphaelratesdev_db_user:rLVRHRLBMhcS9DPW@cluster0.jvz4phr.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')

db = client['markdb']

@keyword('Clean user from database')
def clean_user(user_email):
    users = db['users']
    reservations = db['reservations']

    user = users.find_one({'email': user_email})

    if user:
        reservations.delete_many({'user': user['_id']})
        users.delete_many({'email': user_email})
        print(f'User {user_email} and all their reservations removed')

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    result = users.delete_many({'email': email})
    print(f'Removed {result.deleted_count} user(s) with email {email}')

@keyword('Insert user from database')
def insert_user(user_data):
    users = db['users']

    existing_user = users.find_one({'email': user_data['email']})
    if existing_user:
        print(f'User with email {user_data["email"]} already exists')
        return existing_user['_id']
    
    hash_pass = bcrypt.hashpw(user_data['password'].encode('utf-8'), bcrypt.gensalt(10))
    
    doc = {
        'name': user_data['name'],
        'email': user_data['email'].lower(), 
        'password': hash_pass,
        'role': user_data.get('role', 'user'), 
        'createdAt': user_data.get('createdAt') 
    }
    
    result = users.insert_one(doc)
    print(f'User {user_data["email"]} inserted with ID: {result.inserted_id}')
    return result.inserted_id

@keyword('Insert reservation from database')
def insert_reservation(reservation_data):
    reservations = db['reservations']
    
    doc = {
        'user': reservation_data['user'],
        'session': reservation_data['session'],
        'seats': reservation_data['seats'],
        'totalPrice': reservation_data['totalPrice'],
        'status': reservation_data.get('status', 'confirmed'),
        'paymentStatus': reservation_data.get('paymentStatus', 'completed'),
        'paymentMethod': reservation_data.get('paymentMethod', 'credit_card'),
        'paymentDate': reservation_data.get('paymentDate'),
        'createdAt': reservation_data.get('createdAt')
    }
    
    result = reservations.insert_one(doc)
    print(f'Reservation inserted with ID: {result.inserted_id}')
    return result.inserted_id

@keyword('Clean reservations from database')
def clean_reservations(user_email):
    users = db['users']
    reservations = db['reservations']
    
    user = users.find_one({'email': user_email})
    if user:
        result = reservations.delete_many({'user': user['_id']})
        print(f'Removed {result.deleted_count} reservations for user {user_email}')

@keyword('Get user by email')
def get_user_by_email(email):
    users = db['users']
    user = users.find_one({'email': email.lower()})
    if user:
        print(f'Found user: {user["name"]} ({user["email"]})')
        return user
    else:
        print(f'User with email {email} not found')
        return None

@keyword('Get user reservations')
def get_user_reservations(user_email):
    users = db['users']
    reservations = db['reservations']
    
    user = users.find_one({'email': user_email})
    if not user:
        print(f'User {user_email} not found')
        return []
    
    user_reservations = list(reservations.find({'user': user['_id']}))
    print(f'Found {len(user_reservations)} reservations for user {user_email}')
    return user_reservations

@keyword('Clean all test data')
def clean_all_test_data():
    """Remove todos os dados de teste"""
    test_emails = ['test@example.com', 'raphaelrates.dev@gmail.com', 'testuser@example.com']
    
    for email in test_emails:
        clean_user(email)
    
    print('All test data cleaned')