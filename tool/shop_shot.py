import sys, time
from playwright.sync_api import sync_playwright
out = sys.argv[1]
with sync_playwright() as p:
    b = p.chromium.launch(channel="chrome", headless=True)
    ctx = b.new_context(viewport={"width": 642, "height": 1389}, device_scale_factor=2, locale="it-IT")
    page = ctx.new_page()
    page.goto("http://localhost:8123/?v=%d" % int(time.time()), wait_until="networkidle")
    time.sleep(6)
    page.screenshot(path=out, full_page=False)
    b.close()
print("saved", out)
