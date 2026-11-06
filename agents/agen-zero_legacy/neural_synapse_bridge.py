import os
import time
import subprocess

class FileMonitor:
    def __init__(self, directory_to_watch, sync_command):
        self.directory_to_watch = directory_to_watch
        self.sync_command = sync_command
        self.last_seen = set()

    def get_current_files(self):
        return {f for f in os.listdir(self.directory_to_watch) if os.path.isfile(os.path.join(self.directory_to_watch, f))}

    def sync_files(self):
        print('Syncing files to Google Drive...')
        subprocess.run(self.sync_command, shell=True)
        print('Sync complete!')

    def monitor(self):
        print(f'Monitoring {self.directory_to_watch} for changes...')
        while True:
            current_files = self.get_current_files()
            new_files = current_files - self.last_seen
            removed_files = self.last_seen - current_files

            if new_files:
                print(f'New files detected: {new_files}')
                self.sync_files()  # Sync when new files are added
            if removed_files:
                print(f'Removed files detected: {removed_files}')  # Optional handling for removed files

            self.last_seen = current_files
            time.sleep(10)  # Check for changes every 10 seconds

if __name__ == '__main__':
    # Specify the directory to watch and the rclone sync command
    directory_to_watch = '/path/to/watch'
    sync_command = 'rclone sync /path/to/watch remote:GoogleDriveFolder'  # Modify as needed

    file_monitor = FileMonitor(directory_to_watch, sync_command)
    file_monitor.monitor()