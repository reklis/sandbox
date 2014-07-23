Concept
-------

Simple 4 Digit Passcode View for iPhone and iPad to mimic lock screen

Usage
-----

Create a PasscodeView and wire up a delegate.  Then respond to the callbacks, the only one that is required is

    - (BOOL) passcodeView:(PasscodeView*)passcodeView didEnterPasscode:(NSString*)passcode;

The delegate must return YES or NO to provide a pass/fail status to the view

LICENSE
-------

http://www.opensource.org/licenses/mit-license.php

---

[![gittip](http://img.shields.io/gittip/reklis.svg)](https://www.gittip.com/reklis/)
