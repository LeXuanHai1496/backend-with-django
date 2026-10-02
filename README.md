# Backend-With-Rails

Backend Django

## Tech stack

- Python 3.13
- Django 4.1.9

## Cấu trúc thư mục

```
app/
├── manage.py                    # Django CLI entrypoint — chạy server, migration, tạo app, ...
├── requirements.txt              # Danh sách package Python mà project phụ thuộc
│
├── config/                       # Package cấu hình chung của project
│   ├── settings.py               # Cấu hình Django: database, installed apps, middleware, i18n, static files, ...
│   ├── urls.py                   # Root URL conf — nơi include urls.py của từng app vào project
│   ├── asgi.py                   # Entrypoint cho ASGI server (deploy async, websocket, ...)
│   └── wsgi.py                   # Entrypoint cho WSGI server (deploy production truyền thống)
│
├── authentication/                # App xử lý đăng nhập / xác thực
│   ├── apps.py                    # Đăng ký config của app authentication
│   ├── backends.py                # Custom authentication backend — định nghĩa cách xác thực user (email, token, ...)
│   ├── permissions.py             # Permission class riêng cho các API liên quan đến auth
│   ├── serializers.py             # Serializer cho request/response của login, register, refresh token, ...
│   ├── urls.py                    # Định tuyến các endpoint auth (login, logout, register, ...)
│   └── views.py                   # Xử lý logic cho các endpoint auth
│
├── users/                         # App quản lý User
│   ├── apps.py                    # Đăng ký config của app users
│   ├── admin.py                   # Đăng ký model User với Django admin site
│   ├── models.py                  # Định nghĩa model User (hoặc profile mở rộng từ User)
│   ├── permissions.py             # Permission class cho các thao tác liên quan tới user (vd: chỉ chủ tài khoản mới sửa được)
│   ├── serializers.py             # Serializer cho việc đọc/ghi dữ liệu User qua API
│   ├── urls.py                    # Định tuyến các endpoint liên quan tới user
│   ├── views.py                   # Xử lý logic CRUD/profile cho user
│   ├── tests.py                   # Unit test cho app users
│   └── migrations/                # Lịch sử thay đổi schema database của app users
│
├── projects/                      # App quản lý Project
│   ├── apps.py                    # Đăng ký config của app projects
│   ├── models.py                  # Định nghĩa model Project
│   ├── serializers.py             # Serializer cho việc đọc/ghi dữ liệu Project qua API
│   ├── urls.py                    # Định tuyến các endpoint CRUD cho project
│   ├── views.py                   # Xử lý logic CRUD cho project
│   ├── tests.py                   # Unit test cho app projects
│   └── migrations/                # Lịch sử thay đổi schema database của app projects
│
├── tasks/                          # App quản lý Task (thuộc về một Project)
│   ├── apps.py                     # Đăng ký config của app tasks
│   ├── models.py                   # Định nghĩa model Task, liên kết tới Project (và có thể tới User được giao việc)
│   ├── serializers.py              # Serializer cho việc đọc/ghi dữ liệu Task qua API
│   ├── urls.py                     # Định tuyến các endpoint CRUD cho task
│   ├── views.py                    # Xử lý logic CRUD cho task
│   ├── tests.py                    # Unit test cho app tasks
│   └── migrations/                 # Lịch sử thay đổi schema database của app tasks
│
└── common/                          # Thành phần dùng chung giữa các app
    ├── exceptions.py                 # Custom exception handler — chuẩn hoá format lỗi trả về từ API
    ├── middleware.py                 # Custom middleware — xử lý request/response xuyên suốt toàn app (logging, header, ...)
    ├── pagination.py                 # Custom pagination class dùng chung cho các API danh sách
    └── permissions.py                # Permission class dùng chung cho nhiều app
```

## Mô hình app

```
| App             | Vai trò                                                                 |
|-----------------|-------------------------------------------------------------------------|
| config          | Cấu hình project Django (settings, root URLs, WSGI/ASGI)                |
| authentication  | Đăng nhập/đăng ký, cấp/xác thực token, permission liên quan đến auth    |
| users           | Model User, quản lý hồ sơ người dùng                                    |
| projects        | Model Project, CRUD project                                             |
| tasks           | Model Task, gắn với Project, CRUD task                                  |
| common          | Middleware, pagination, exception handler, permission dùng chung        |
```

## Chạy application ở local

### 1. Yêu cầu môi trường

- Python 3.10+ (khuyến nghị dùng đúng bản đang có: Python 3.13)
- pip

### 2. Tạo và kích hoạt virtualenv

Dự án đã có sẵn thư mục .venv, chỉ cần kích hoạt:

source .venv/bin/activate

Nếu chưa có hoặc muốn tạo mới:

python3 -m venv .venv
source .venv/bin/activate

### 3. Cài dependency

pip install -r requirements.txt

### 4. Khai báo các app vào settings

Đảm bảo 5 app hiện có đã được thêm vào INSTALLED_APPS trong config/settings.py:

```
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'authentication',
    'common',
    'projects',
    'tasks',
    'users',
]
```

### 5. Chạy migration

python manage.py migrate

### 6. (Tuỳ chọn) Tạo superuser để vào Django admin

```
python manage.py createsuperuser
```

### 7. Chạy server

```
python manage.py runserver
```

Mặc định server chạy tại http://127.0.0.1:8000/. Trang admin tại http://127.0.0.1:8000/admin/.