-- SQL Script to populate your portfolio database with existing data
-- Run this in your Supabase SQL Editor after creating the tables

-- Insert Projects
INSERT INTO projects (title, description, image_path, link) VALUES
('To Do List App', 
 'A cross-platform To-Do app with local data storage and a clean, intuitive interface for managing daily tasks.', 
 'assets/images/ToDo.png', 
 'https://github.com/MrDaniel07/ToDoApp'),

('E-commerce mobile app design', 
 'A high-fidelity mobile app UI for an e-commerce platform, designed with intuitive navigation based on user flow analysis and wireframes.', 
 'assets/images/Crypt.png', 
 'https://www.figma.com/design/0WI5faaZQ79XhCtuXVdShP/First-Design?node-id=0-1&t=ZhhZefX4W3QjkvcH-1'),

('Safety Awareness Game Website', 
 'An interactive fire safety awareness game set in a high-rise office building. Players must make quick decisions, answer safety questions, and navigate through a burning environment to reach safety—testing and improving their emergency preparedness in a fun, gamified way.', 
 'assets/images/Fire.png', 
 'https://firesafetygame.netlify.app/'),

('"Breach in the Cloud" security hands-on lab from Pwned Labs', 
 'I tracked a suspicious IAM user through CloudTrail logs, analyzed AWS activity, and used attacker credentials (in a safe lab setup) to locate an exploited S3/DynamoDB resource — eventually recovering the flag from a compromised file.', 
 'assets/images/lab.png', 
 'https://pwnedlabs.io/@AnyahuruDan07'),

('Design Portfolio Landing Page', 
 'A sleek, modern landing page showcasing my design portfolio with responsive layouts and interactive elements to attract potential clients.', 
 'assets/images/design.png', 
 'https://any-dan-design-portfolio.figma.site/');

-- Insert Experiences
INSERT INTO experiences (title, company, period, responsibilities, image_path) VALUES
('Internship [Cybersecurity Analyst]', 
 'IHS Towers', 
 'Jan 2025 – Feb 2025', 
 '["Monitored Sophos alerts, responded to malware, and collaborated with Red Team to enhance protection.", "Gained experience using Sophos Endpoint Protection, device control, and email security."]'::jsonb,
 'assets/images/Ihs.png'),

('Internship [Software Engineer & Data Analyst]', 
 'Seplat Energy Plc', 
 'Feb 2025 – June 2025', 
 '["Redesigned inventory system for usability and workflow.", "Built interactive game with leaderboard, data collection, and storage.", "Created Power BI dashboard to visualize Microsoft Forms data.", "Analyzed survey results in Excel, conducted HSE solutions, and supported weekly meetings."]'::jsonb,
 'assets/images/Seplat.png'),

('Part-time [Product Manager & Designer]', 
 'Alcott Courier And Logistics Limited', 
 'Aug 2025 – Present', 
 '["Define product vision and priorities.", "Design User-Centered Experiences.", "Translate Ideas into Actionable Tasks.", "Coordinate Development & Design Handoff.", "Test, iterate, and Communicate Progress."]'::jsonb,
 'assets/images/alcot.png');

-- Insert Default Settings (password and SEO)
INSERT INTO settings (admin_password, seo_title, seo_description, seo_keywords, seo_author, seo_og_image) VALUES
('admin123', 
 'Anyahuru Oluebube Daniel - Portfolio', 
 'Software Engineer and Cloud Security Engineer specializing in application development, cloud security, and cybersecurity compliance', 
 'software engineer, cloud security, cybersecurity, flutter developer, AWS, portfolio, fullstack developer',
 'Anyahuru Oluebube Daniel',
 '');

-- Verify the data was inserted
SELECT COUNT(*) as project_count FROM projects;
SELECT COUNT(*) as experience_count FROM experiences;
SELECT COUNT(*) as settings_count FROM settings;

-- View all projects
SELECT id, title, LEFT(description, 50) as description_preview, link FROM projects ORDER BY created_at DESC;

-- View all experiences
SELECT id, company, title, period FROM experiences ORDER BY created_at DESC;
