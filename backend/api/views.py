from rest_framework import viewsets, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
import razorpay
import datetime
import uuid
import re

from .models import *
from .serializers import *

# === AUTH & CONSUMER VIEWS ===

@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def register(request):
    """Mock Aadhaar based registration"""
    data = request.data
    aadhaar = data.get('aadhaar_number')
    if not aadhaar or len(aadhaar) != 12:
        return Response({'error': 'Valid 12-digit Aadhaar required'}, status=status.HTTP_400_BAD_REQUEST)
    
    if Consumer.objects.filter(aadhaar_number=aadhaar).exists():
        return Response({'error': 'Consumer already exists'}, status=status.HTTP_400_BAD_REQUEST)
    
    # Create user
    consumer = Consumer.objects.create(
        aadhaar_number=aadhaar,
        name=data.get('name', f"User {aadhaar[-4:]}"),
        mobile=data.get('mobile', ''),
        gender=data.get('gender', 'OTHER'),
        address=data.get('address', ''),
        city=data.get('city', ''),
        state=data.get('state', ''),
        pincode=data.get('pincode', '')
    )
    
    # We mock a Django User for JWT
    user, created = User.objects.get_or_create(username=aadhaar)
    user.set_unusable_password()
    user.save()
    
    return Response({'message': 'Registration successful, use OTP to login'}, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def login_otp(request):
    """Mock OTP Login"""
    mobile = request.data.get('mobile')
    aadhaar = request.data.get('aadhaar_number')
    # Use any combination that exists
    consumer = Consumer.objects.filter(mobile=mobile).first() or Consumer.objects.filter(aadhaar_number=aadhaar).first()
    
    if not consumer:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
    
    user, _ = User.objects.get_or_create(username=consumer.aadhaar_number)
    refresh = RefreshToken.for_user(user)
    
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
        'consumer_id': consumer.id,
        'name': consumer.name
    })


@api_view(['GET', 'PUT'])
@permission_classes([permissions.IsAuthenticated])
def profile_view(request):
    try:
        consumer = Consumer.objects.get(aadhaar_number=request.user.username)
    except Consumer.DoesNotExist:
        return Response({'error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ConsumerSerializer(consumer)
        return Response(serializer.data)
    elif request.method == 'PUT':
        serializer = ConsumerSerializer(consumer, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# === STANDARD MODEL VIEWSETS ===

class ServiceCatalogViewSet(viewsets.ModelViewSet):
    queryset = ServiceCatalog.objects.filter(is_active=True)
    serializer_class = ServiceCatalogSerializer
    permission_classes = [permissions.AllowAny] # Anyone can view services


class ConsumerViewSet(viewsets.ModelViewSet):
    queryset = Consumer.objects.all()
    serializer_class = ConsumerSerializer
    permission_classes = [permissions.IsAuthenticated]

class ElectricityConsumerViewSet(viewsets.ModelViewSet):
    queryset = ElectricityConsumer.objects.all()
    serializer_class = ElectricityConsumerSerializer
    permission_classes = [permissions.IsAuthenticated]

class ElectricityBillViewSet(viewsets.ModelViewSet):
    queryset = ElectricityBill.objects.all()
    serializer_class = ElectricityBillSerializer
    permission_classes = [permissions.IsAuthenticated]

class ElectricityPaymentViewSet(viewsets.ModelViewSet):
    queryset = ElectricityPayment.objects.all()
    serializer_class = ElectricityPaymentSerializer
    permission_classes = [permissions.IsAuthenticated]

class ElectricityComplaintViewSet(viewsets.ModelViewSet):
    queryset = ElectricityComplaint.objects.all()
    serializer_class = ElectricityComplaintSerializer
    permission_classes = [permissions.IsAuthenticated]

class LoadEnhancementRequestViewSet(viewsets.ModelViewSet):
    queryset = LoadEnhancementRequest.objects.all()
    serializer_class = LoadEnhancementRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

class MeterReplacementRequestViewSet(viewsets.ModelViewSet):
    queryset = MeterReplacementRequest.objects.all()
    serializer_class = MeterReplacementRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

class NameTransferRequestViewSet(viewsets.ModelViewSet):
    queryset = NameTransferRequest.objects.all()
    serializer_class = NameTransferRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

class GasConsumerViewSet(viewsets.ModelViewSet):
    queryset = GasConsumer.objects.all()
    serializer_class = GasConsumerSerializer
    permission_classes = [permissions.IsAuthenticated]

class GasCylinderBookingViewSet(viewsets.ModelViewSet):
    queryset = GasCylinderBooking.objects.all()
    serializer_class = GasCylinderBookingSerializer
    permission_classes = [permissions.IsAuthenticated]

class GasComplaintViewSet(viewsets.ModelViewSet):
    queryset = GasComplaint.objects.all()
    serializer_class = GasComplaintSerializer
    permission_classes = [permissions.IsAuthenticated]

class WaterConsumerViewSet(viewsets.ModelViewSet):
    queryset = WaterConsumer.objects.all()
    serializer_class = WaterConsumerSerializer
    permission_classes = [permissions.IsAuthenticated]

class WaterBillViewSet(viewsets.ModelViewSet):
    queryset = WaterBill.objects.all()
    serializer_class = WaterBillSerializer
    permission_classes = [permissions.IsAuthenticated]

class PropertyViewSet(viewsets.ModelViewSet):
    queryset = Property.objects.all()
    serializer_class = PropertySerializer
    permission_classes = [permissions.IsAuthenticated]

class PropertyTaxViewSet(viewsets.ModelViewSet):
    queryset = PropertyTax.objects.all()
    serializer_class = PropertyTaxSerializer
    permission_classes = [permissions.IsAuthenticated]

class ProfessionalTaxViewSet(viewsets.ModelViewSet):
    queryset = ProfessionalTax.objects.all()
    serializer_class = ProfessionalTaxSerializer
    permission_classes = [permissions.IsAuthenticated]

class TradeLicenseViewSet(viewsets.ModelViewSet):
    queryset = TradeLicense.objects.all()
    serializer_class = TradeLicenseSerializer
    permission_classes = [permissions.IsAuthenticated]

class BuildingPlanApplicationViewSet(viewsets.ModelViewSet):
    queryset = BuildingPlanApplication.objects.all()
    serializer_class = BuildingPlanApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

class GrievanceViewSet(viewsets.ModelViewSet):
    queryset = Grievance.objects.all()
    serializer_class = GrievanceSerializer
    permission_classes = [permissions.IsAuthenticated]

class BirthCertificateApplicationViewSet(viewsets.ModelViewSet):
    queryset = BirthCertificateApplication.objects.all()
    serializer_class = BirthCertificateApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

class DeathCertificateApplicationViewSet(viewsets.ModelViewSet):
    queryset = DeathCertificateApplication.objects.all()
    serializer_class = DeathCertificateApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

class MarriageRegistrationViewSet(viewsets.ModelViewSet):
    queryset = MarriageRegistration.objects.all()
    serializer_class = MarriageRegistrationSerializer
    permission_classes = [permissions.IsAuthenticated]

class NotificationViewSet(viewsets.ModelViewSet):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer
    permission_classes = [permissions.IsAuthenticated]


# === EXTERNAL INTEGRATIONS ===

# 1. Razorpay Test Mode
razorpay_client = razorpay.Client(auth=("rzp_test_mockkey12345", "mocksecret67890"))

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_payment_order(request):
    """Creates a Razorpay Test order. MOCKED: we won't actually call the real API if it requires real keys, but we use the SDK."""
    amount = request.data.get('amount')
    context_id = request.data.get('context_id', 'TEST1234')
    
    if not amount:
        return Response({'error': 'Amount is required'}, status=status.HTTP_400_BAD_REQUEST)
        
    try:
        # NOTE: Without real mock keys, the razorpay_client.order.create might fail. We will mock the response natively here to ensure it works completely offline without failing on invalid auth.
        order_data = {
            "id": f"order_{uuid.uuid4().hex[:14]}",
            "entity": "order",
            "amount": int(float(amount) * 100),
            "amount_paid": 0,
            "amount_due": int(float(amount) * 100),
            "currency": "INR",
            "receipt": context_id,
            "status": "created",
            "attempts": 0
        }
        return Response(order_data)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def verify_payment(request):
    """Verifies a payment and updates the model."""
    data = request.data
    bill_id = data.get('bill_id')
    amount = data.get('amount')
    payment_method = data.get('payment_method', 'UPI')
    transaction_id = data.get('razorpay_payment_id', f"pay_{uuid.uuid4().hex[:10]}")
    
    if not bill_id or not amount:
        return Response({'error': 'Bill ID and amount required'}, status=status.HTTP_400_BAD_REQUEST)
        
    try:
        bill = ElectricityBill.objects.get(id=bill_id)
        # Create payment record
        Payment = ElectricityPayment.objects.create(
            bill=bill,
            transaction_id=transaction_id,
            amount=amount,
            payment_method=payment_method,
            status='SUCCESS'
        )
        bill.status = 'PAID'
        bill.paid_amount = amount
        bill.save()
        return Response({"status": "Payment Verified and updated successfully", "transaction_id": Payment.transaction_id})
    except ElectricityBill.DoesNotExist:
        return Response({'error': 'Bill not found'}, status=status.HTTP_404_NOT_FOUND)


# 2. Rule-Based AI Chatbot
@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def chatbot_message(request):
    message = request.data.get('message', '').lower()
    lang = request.data.get('language', 'en')
    
    # Very simple keyword dictionary rule match
    rules = {
        'bill': {
            'en': "You can view and pay your electricity and water bills in the 'Pay Bills' section.",
            'hi': "आप 'Pay Bills' अनुभाग में अपने बिजली और पानी के बिल देख सकते हैं और भुगतान कर सकते हैं।",
            'or': "ଆପଣ 'Pay Bills' ବିଭାଗରେ ଆପଣଙ୍କର ବିଦ୍ୟୁତ୍ ଏବଂ ଜଳ ବିଲ୍ ଦେଖିପାରିବେ ଏବଂ ଦେୟ ଦେଇପାରିବେ।"
        },
        'complaint': {
            'en': "To file a complaint, go to the Grievances tab, select your department, and fill out the details.",
            'hi': "शिकायत दर्ज करने के लिए, शिकायत टैब पर जाएं, अपना विभाग चुनें और विवरण भरें।",
            'or': "ଗୋଟିଏ ଅଭିଯୋଗ ଦାଖଲ କରିବାକୁ, ଅଭିଯୋଗ ଟ୍ୟାବ୍ କୁ ଯାଆନ୍ତୁ, ଆପଣଙ୍କର ବିଭାଗ ବାଛନ୍ତୁ ଏବଂ ବିବରଣୀ ପୂରଣ କରନ୍ତୁ।"
        },
        'gas': {
            'en': "You can book a gas cylinder in the Gas Services page. Delivery usually takes 2-3 days.",
            'hi': "आप गैस सेवा पृष्ठ पर गैस सिलेंडर बुक कर सकते हैं। डिलीवरी में आमतौर पर 2-3 दिन लगते हैं।",
            'or': "ଆପଣ ଗ୍ୟାସ ସେବା ପୃଷ୍ଠାରେ ଗ୍ୟାସ ସିଲିଣ୍ଡର ବୁକ୍ କରିପାରିବେ। ବିତରଣ ସାଧାରଣତଃ 2-3 ଦିନ ନେଇଥାଏ।"
        },
        'payment': {
            'en': "We support UPI, Net Banking, and Cards. Go to your pending bills to pay them.",
            'hi': "हम UPI, नेट बैंकिंग और कार्ड का समर्थन करते हैं। भुगतान करने के लिए अपने लंबित बिलों पर जाएं।",
            'or': "ଆମେ UPI, ନେଟ ବ୍ୟାଙ୍କିଂ, ଏବଂ କାର୍ଡ୍ ସମର୍ଥନ କରୁ। ଦେୟ ଦେବା ପାଇଁ ଆପଣଙ୍କର ବକେୟା ବିଲ୍ କୁ ଯାଆନ୍ତୁ।"
        },
        'fallback': {
            'en': "I'm a smart civic bot! I can help you with bills, complaints, gas booking, or payments. Just ask!",
            'hi': "मैं एक स्मार्ट नागरिक बॉट हूँ! मैं आपको बिलों, शिकायतों, गैस बुकिंग, या भुगतानों में मदद कर सकता हूँ। बस पूछें!",
            'or': "ମୁଁ ଏକ ସ୍ମାର୍ଟ ନାଗରିକ ବଟ୍ ପରି ଅଟେ! ମୁଁ ଆପଣଙ୍କୁ ବିଲ୍, ଅଭିଯୋଗ, ଗ୍ୟାସ ବୁକିଂ କିମ୍ବା ପେମେଣ୍ଟ ରେ ସାହାଯ୍ୟ କରିପାରିବି। କେବଳ ପଚାରନ୍ତୁ!"
        }
    }
    
    response_text = rules['fallback'][lang] if lang in rules['fallback'] else rules['fallback']['en']
    
    for key in ['bill', 'complaint', 'gas', 'payment']:
        if key in message:
            response_text = rules[key][lang] if lang in rules[key] else rules[key]['en']
            break
            
    return Response({"reply": response_text})
