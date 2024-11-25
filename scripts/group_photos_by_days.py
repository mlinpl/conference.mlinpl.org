from datetime import datetime
import os
from PIL import Image
import piexif
from collections import defaultdict
import yaml


def extract_datetime(image_path):
    """Extract the datetime from image EXIF data."""
    try:
        img = Image.open(image_path)
        if "exif" not in img.info:
            # If no EXIF data, use file modification time as fallback
            return datetime.fromtimestamp(os.path.getmtime(image_path))
        
        exif_dict = piexif.load(img.info["exif"])
        
        # Try to get DateTimeOriginal first, then DateTime as fallback
        date_time_str = None
        if piexif.ExifIFD.DateTimeOriginal in exif_dict["Exif"]:
            date_time_str = exif_dict["Exif"][piexif.ExifIFD.DateTimeOriginal].decode()
        elif piexif.ImageIFD.DateTime in exif_dict["0th"]:
            date_time_str = exif_dict["0th"][piexif.ImageIFD.DateTime].decode()
            
        if date_time_str:
            return datetime.strptime(date_time_str, "%Y:%m:%d %H:%M:%S")
        
        # If no EXIF datetime found, use file modification time
        return datetime.fromtimestamp(os.path.getmtime(image_path))
        
    except Exception as e:
        print(f"Error processing {image_path}: {str(e)}")
        return datetime.fromtimestamp(os.path.getmtime(image_path))

def organize_photos(thumbnails_dir):
    """Organize photos by date and create YAML structure."""
    # Dictionary to store photos grouped by date
    photos_by_date = defaultdict(list)
    
    # Process all webp files in the directory
    for filename in os.listdir(thumbnails_dir):
        if filename.endswith('.webp'):
            thumb_path = os.path.join(thumbnails_dir, filename)
            taken_datetime = extract_datetime(thumb_path)
            
            # Create photo entry
            photo_entry = {'filename': filename}
                
            # Group by date
            date_key = taken_datetime.strftime('%Y-%m-%d')
            photos_by_date[date_key].append((photo_entry, taken_datetime))
    
    # Sort photos by datetime and create final structure
    photo_groups = []
    for i, date in enumerate(sorted(photos_by_date.keys()), start=1):
        # Sort photos within each day by time
        day_photos = sorted(photos_by_date[date], key=lambda x: x[1])
        
        # Create group entry
        group = {
            'name': f'<i class="fa-solid fa-calendar-day"></i> Day {i} - {datetime.strptime(date, "%Y-%m-%d").strftime("%A / %d %B %Y")}',
            'src-dir': 'images/photos/2400x1600',
            'thumbnails-dir': 'images/photos/thumbnails',
            'default-width': 2400,
            'default-height': 1600,
            'photos': [photo[0] for photo in day_photos]
        }
        photo_groups.append(group)
    
    return photo_groups


if __name__ == "__main__":
    thumbnails_dir = "images/photos/thumbnails"
    
    if not os.path.exists(thumbnails_dir):
        print(f"Error: Directory not found!")
        exit(1)
    
    photo_groups = organize_photos(thumbnails_dir)
    
    # Write to YAML file
    data_dir = "_data"
    with open(os.path.join(data_dir, "photos.yml"), "w") as f:
        yaml.dump(photo_groups, f, sort_keys=False, allow_unicode=True)
    
    print("Photo organization complete! Results written to _data/photos.yml")
