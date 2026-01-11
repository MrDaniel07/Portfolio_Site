# Supabase Database Setup for Admin Panel

## Required Tables

You need to create three tables in your Supabase project:

### 1. Projects Table

Run this SQL in your Supabase SQL Editor:

```sql
CREATE TABLE projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  image_path TEXT NOT NULL,
  link TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for development)
-- For production, you should restrict these policies
CREATE POLICY "Enable all operations for projects" ON projects
FOR ALL USING (true) WITH CHECK (true);
```

### 2. Experiences Table

Run this SQL in your Supabase SQL Editor:

```sql
CREATE TABLE experiences (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  company TEXT NOT NULL,
  period TEXT NOT NULL,
  responsibilities JSONB NOT NULL DEFAULT '[]',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE experiences ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for development)
-- For production, you should restrict these policies
CREATE POLICY "Enable all operations for experiences" ON experiences
FOR ALL USING (true) WITH CHECK (true);
```

### 3. Settings Table

Run this SQL in your Supabase SQL Editor:

```sql
CREATE TABLE settings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  admin_password TEXT NOT NULL DEFAULT 'admin123',
  seo_title TEXT NOT NULL DEFAULT 'Anyahuru Oluebube Daniel - Portfolio',
  seo_description TEXT NOT NULL DEFAULT 'Software Engineer and Cloud Security Engineer',
  seo_keywords TEXT NOT NULL DEFAULT 'software engineer, cloud security, cybersecurity',
  seo_author TEXT NOT NULL DEFAULT 'Anyahuru Oluebube Daniel',
  seo_og_image TEXT DEFAULT '',
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for development)
CREATE POLICY "Enable all operations for settings" ON settings
FOR ALL USING (true) WITH CHECK (true);

-- Insert default settings
INSERT INTO settings (admin_password, seo_title, seo_description, seo_keywords, seo_author) VALUES
('admin123', 'Anyahuru Oluebube Daniel - Portfolio', 
'Software Engineer and Cloud Security Engineer specializing in application development and cybersecurity', 
'software engineer, cloud security, cybersecurity, flutter developer, AWS, portfolio',
'Anyahuru Oluebube Daniel');
```

## Admin Panel Access

- **Default Admin Password**: `admin123`
- **Access URL**: Click the floating button (bottom right) or navigate to `/admin` route
- **Change Password**: Go to Admin Panel → Settings → Change Password

## Features

- ✅ CRUD operations for Projects
- ✅ CRUD operations for Experiences
- ✅ Password Management (Change admin password dynamically)
- ✅ SEO Settings (Configure meta tags, keywords, descriptions)
- ✅ Real-time data sync with Supabase
- ✅ Password-protected admin panel
- ✅ Responsive forms with validation
- ✅ Dynamic responsibilities list for experiences

## Usage

1. Run the SQL commands above in your Supabase dashboard (create all 3 tables)
2. The app will automatically fetch data from Supabase
3. Click the admin button to manage content
4. Use Settings tab to change password and configure SEO
5. Changes are immediately reflected on the portfolio

## Security Notes

⚠️ **Important for Production**:

1. Change the admin password via Settings tab (don't hardcode it anymore)
2. Implement proper authentication (Supabase Auth recommended)
3. Update RLS policies to restrict access
4. Move credentials to environment variables
5. Consider adding image upload functionality
6. Add robots.txt and sitemap.xml for better SEO

## Migrating Existing Data

To add your current hardcoded projects and experiences to Supabase:

1. Go to admin panel (`/admin`)
2. Login with password
3. Manually add each project and experience
4. Or use SQL INSERT statements in Supabase

Example INSERT for projects:
```sql
INSERT INTO projects (title, description, image_path, link) VALUES
('To Do List App', 'A cross-platform To-Do app...', 'assets/images/ToDo.png', 'https://github.com/...');
```

Example INSERT for experiences:
```sql
INSERT INTO experiences (title, company, period, responsibilities) VALUES
('Cybersecurity Analyst', 'IHS Towers', 'Jan 2025 – Feb 2025', 
'["Monitored Sophos alerts", "Gained experience using Sophos Endpoint Protection"]'::jsonb);
```
