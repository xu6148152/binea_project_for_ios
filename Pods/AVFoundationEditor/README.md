# AVFoundationEditor

#### <a href="http://www.bobmccune.com/2013/11/08/learning-av-foundation-book-in-development/">Learning AV Foundation</a> is currently under development and a Rough Cut is now available on <a href="http://my.safaribooksonline.com/book/web-applications-and-services/9780133563856">Safari Books Online</a>.

This is the companion app to Bob McCune's "Mastering Video" presentation at Renaissance 2014.

![playback demo](https://raw.github.com/tapharmonic/AVFoundationEditor/master/ScreenShots/AVFoundationEditor.jpg)

The demo app is a simple video editing application patterned after iMovie for iOS.  Here's a quick description of its features:

### Composition ###
Audio and video clips can be arranged along a timeline.  This demostrates using AVComposition to build simple and complex temporal arrangements of AVAssets.

A user can select video clips from the media picker and arrange them along the timeline.  Basic drag and drop is implemented to allow for reordering of clips and an individual clip's duration can be trimmed.

The app also allows adding audio tracks to the composition.  Limited DnD support is provided to move the voiceover track within the overall timeline.

### Audio Mixing ###
Audio fades and ducking can be enabled from the settings menu.  This demonstrates using AVAudioMix to apply fades and ducking to the soundtrack.

### Video Transitions ###
Video transitions can be enabled from the settings menu.  This demonstrates how to use AVVideoComposition to create simple transition effects such as cross disolves and push transitions.

### Layering Content ###
Animated titles can be enabled from the settings menu.  This demonstrates how to AVSynchronizedLayer to provide animated layering effects such as titling.


## iOS and Device Support ##
This is an iPad-only app and requires iOS 7.


## Contact ##

Bob McCune<br/>
http://bobmccune.com<br/>
<a href="https://twitter.com/bobmccune">@bobmccune</a><br/>
http://tapharmonic.com<br/>
