from django.http import HttpResponse
from app.models import Product
from django.shortcuts import render

p = Product()
#p.id=1
#p.name="name1"
#p.save()

products = []
for i in range(1,10):
    products.append({'id': i, 'name': 'name'+str(i)})

def index(request):
    print(Product.objects.first().name)
    return render(request,
        'index.html',
        {
            'title': 'title',
            'bodystart': 'bodystart',
            'products': Product.objects.all(),
            'bodystop': 'bodystop',
        }
    )
