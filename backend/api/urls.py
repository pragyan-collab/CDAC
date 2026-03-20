from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'consumers', views.ConsumerViewSet)
router.register(r'service-catalog', views.ServiceCatalogViewSet)

router.register(r'electricity-consumers', views.ElectricityConsumerViewSet)
router.register(r'electricity-bills', views.ElectricityBillViewSet)
router.register(r'electricity-payments', views.ElectricityPaymentViewSet)
router.register(r'electricity-complaints', views.ElectricityComplaintViewSet)
router.register(r'load-requests', views.LoadEnhancementRequestViewSet)
router.register(r'meter-requests', views.MeterReplacementRequestViewSet)
router.register(r'name-transfers', views.NameTransferRequestViewSet)

router.register(r'gas-consumers', views.GasConsumerViewSet)
router.register(r'gas-bookings', views.GasCylinderBookingViewSet)
router.register(r'gas-complaints', views.GasComplaintViewSet)

router.register(r'water-consumers', views.WaterConsumerViewSet)
router.register(r'water-bills', views.WaterBillViewSet)

router.register(r'properties', views.PropertyViewSet)
router.register(r'property-taxes', views.PropertyTaxViewSet)
router.register(r'professional-taxes', views.ProfessionalTaxViewSet)
router.register(r'trade-licenses', views.TradeLicenseViewSet)
router.register(r'building-plans', views.BuildingPlanApplicationViewSet)
router.register(r'grievances', views.GrievanceViewSet)

router.register(r'birth-certificates', views.BirthCertificateApplicationViewSet)
router.register(r'death-certificates', views.DeathCertificateApplicationViewSet)
router.register(r'marriage-registrations', views.MarriageRegistrationViewSet)
router.register(r'notifications', views.NotificationViewSet)

urlpatterns = [
    # Custom endpoints
    path('auth/register/', views.register, name='register'),
    path('auth/login/', views.login_otp, name='login_otp'),
    path('auth/profile/', views.profile_view, name='profile_view'),
    
    path('payment/create-order/', views.create_payment_order, name='create_payment_order'),
    path('payment/verify/', views.verify_payment, name='verify_payment'),
    
    path('chatbot/', views.chatbot_message, name='chatbot'),
    
    # ViewSets
    path('', include(router.urls)),
]
