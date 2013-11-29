from __future__ import absolute_import
from powerline.theme import requires_segment_info

@requires_segment_info
def my_now_playing(pl, segment_info):
    '''Return now playing'''
    data = os.popen("osascript /Users/burke/.config/powerline/powerline/segments/rdio.script").read()
    return data
