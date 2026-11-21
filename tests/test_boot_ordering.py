from pathlib import Path
import unittest


SYSTEMD = Path(__file__).resolve().parents[1] / "sparse/usr/lib/systemd/system"


class AndroidBootOrderingTests(unittest.TestCase):
    def test_container_preparation_precedes_android_startup(self):
        lines = (SYSTEMD / "droid-hal-init.service.d/blueline.conf").read_text().splitlines()
        commands = [line for line in lines if line.startswith("ExecStartPre=")]
        self.assertEqual(commands, [
            "ExecStartPre=",
            "ExecStartPre=/usr/bin/droid/blueline-prepare-container.sh",
            "ExecStartPre=/bin/sh /usr/bin/droid/droid-hal-startup.sh",
        ])
        self.assertIn("Requires=mount-android.service", lines)
        self.assertIn("After=mount-android.service", lines)

    def test_mount_service_waits_for_partition_mounts(self):
        lines = (SYSTEMD / "mount-android.service.d/blueline.conf").read_text().splitlines()
        self.assertEqual(lines, ["[Service]", "Type=oneshot"])


if __name__ == "__main__":
    unittest.main()
