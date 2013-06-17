Amendments-iOS-App
==================

An app for iOS that offers a lightweight interface to the Amendments to the United States Consitution. 

Implements the following features:

<ul>
<li> The complete list of 27 amendments with amendment title, subtitle, and thumbnail icon, rendered as Table View cells. 
<li> A custom UIView animation based zoom segue to each amendment's icon detail. 
<li> A summary page for each amendment, with paths to an extended summary page, original text page, and a current amendment news page.
<li> An amendment news page for each amendment which fetches from Google News to show the latest articles on the web discussing each amendment.
<li> A caching policy that uses NSCache and a custom API that allows for a togglable cache update interval.
<li> Article favoriting using NSUserDefaults.
<li> Supports all interface orientations and optimized subview layouts between iPhone 4 and iPhone 5 dimensions.
<li> Integration and extensions of the following third-party tools:
  <ul>
  <li>iRate
  <li>Google's GTMHTTPFetcher
  <li>SVWebViewController
  <li>MYIntroductionView
  </ul>
</ul>
