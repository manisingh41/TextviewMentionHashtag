# TextviewMentionHashtag
A custom textview for showing hashtag, mention url or attachments. When you start with # and give space after writing a word it turns out to be hashtag, similar for the mention when use with @. URL can be used too.

To use this framework using cocoapods:

pod 'CustomMention', :git => 'https://github.com/manisingh41/TextviewMentionHashtag'

Import the framework in the viewcontroller:

import CustomMention

Create an outlet of your view and subclass it:

@IBOutlet weak var YOUR_UIVIEW_NAME: NewcustomMentionTextview!

In the viewDidLoad(), paste these lines:

YOUR_UIVIEW_NAME.createCustomTextview(wid: YOUR_UIVIEW.frame.size.width) //to create a custom textview with customized size.

YOUR_UIVIEW_NAME.textviewEditMode?.checkPlaceholder() // to check the placeholder.

YOUR_UIVIEW_NAME.adjustFramesTextView() // to adjust the frame if there is already text given in the beginning.

YOUR_UIVIEW_NAME.textviewEditMode?.becomeFirstResponder() // to make the textview first responder
