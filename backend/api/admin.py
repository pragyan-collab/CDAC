from django.contrib import admin
from .models import *

# Decorate models for simple Registration but use custom logic for deeper models

@admin.register(Consumer)
class ConsumerAdmin(admin.ModelAdmin):
    list_display = ('name', 'aadhaar_number', 'mobile', 'city')
    search_fields = ('name', 'aadhaar_number', 'mobile')

@admin.register(ElectricityConsumer)
class ElectricityConsumerAdmin(admin.ModelAdmin):
    list_display = ('consumer_number', 'consumer', 'connection_type', 'sanctioned_load')
    search_fields = ('consumer_number', 'consumer__name')

@admin.register(ElectricityBill)
class ElectricityBillAdmin(admin.ModelAdmin):
    list_display = ('bill_number', 'consumer', 'total_amount', 'status', 'due_date')
    list_filter = ('status', 'bill_date')
    search_fields = ('bill_number',)

@admin.register(ElectricityPayment)
class ElectricityPaymentAdmin(admin.ModelAdmin):
    list_display = ('transaction_id', 'bill', 'amount', 'status', 'payment_date')
    list_filter = ('status', 'payment_method')

@admin.register(ElectricityComplaint)
class ElectricityComplaintAdmin(admin.ModelAdmin):
    list_display = ('complaint_number', 'complaint_type', 'status', 'priority', 'created_at')
    list_filter = ('status', 'priority', 'complaint_type')
    
@admin.register(LoadEnhancementRequest)
class LoadEnhancementRequestAdmin(admin.ModelAdmin):
    list_display = ('request_number', 'consumer', 'current_load', 'requested_load', 'status')
    list_filter = ('status',)

@admin.register(MeterReplacementRequest)
class MeterReplacementRequestAdmin(admin.ModelAdmin):
    list_display = ('request_number', 'consumer', 'reason', 'status')
    list_filter = ('status',)

@admin.register(NameTransferRequest)
class NameTransferRequestAdmin(admin.ModelAdmin):
    list_display = ('request_number', 'new_owner_name', 'status')
    list_filter = ('status',)

# GAS 
@admin.register(GasConsumer)
class GasConsumerAdmin(admin.ModelAdmin):
    list_display = ('consumer_number', 'distributor')

@admin.register(GasCylinderBooking)
class GasCylinderBookingAdmin(admin.ModelAdmin):
    list_display = ('booking_number', 'cylinder_type', 'status', 'expected_delivery_date')
    list_filter = ('status',)

# WATER
@admin.register(WaterConsumer)
class WaterConsumerAdmin(admin.ModelAdmin):
    list_display = ('consumer_number', 'property_type')

@admin.register(WaterBill)
class WaterBillAdmin(admin.ModelAdmin):
    list_display = ('bill_number', 'total_amount', 'status')
    list_filter = ('status',)

# MUNICIPAL
@admin.register(Grievance)
class GrievanceAdmin(admin.ModelAdmin):
    list_display = ('grievance_number', 'department', 'status', 'created_at')
    list_filter = ('status', 'department')

admin.site.register(ServiceCatalog)
admin.site.register(Property)
admin.site.register(PropertyTax)
admin.site.register(ProfessionalTax)
admin.site.register(TradeLicense)
admin.site.register(BuildingPlanApplication)
admin.site.register(BirthCertificateApplication)
admin.site.register(DeathCertificateApplication)
admin.site.register(MarriageRegistration)
