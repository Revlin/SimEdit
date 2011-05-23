/* generated javascript */
var skin = 'monobook';
var stylepath = 'http://d1yjxggot69855.cloudfront.net/skins';

/* MediaWiki:Common.js */
/** "Technical restrictions" title fix *****************************************
 *
 *  Description:
 *  Maintainers: User:Interiot, User:Mets501
 */
 
// For pages that have something like Template:Lowercase, replace the title, but only if it is cut-and-pasteable as a valid wikilink.
//	(for instance iPod's title is updated.  But [[C#]] is not an equivalent wikilink, so [[C Sharp]] doesn't have its main title changed)
//
// The function looks for a banner like this: 
 // <div id="RealTitleBanner">    <!-- div that gets hidden -->
 //   <span id="RealTitle">title</span>
 // </div>
 // An element with id=DisableRealTitle disables the function.
var disableRealTitle = 0;		// users can disable this by making this true from their monobook.js
if (wgIsArticle) {			// don't display the RealTitle when editing, since it is apparently inconsistent (doesn't show when editing sections, doesn't show when not previewing)
    addOnloadHook(function() {
	try {
		var realTitleBanner = document.getElementById("RealTitleBanner");
		if (realTitleBanner && !document.getElementById("DisableRealTitle") && !disableRealTitle) {
			var realTitle = document.getElementById("RealTitle");
			if (realTitle) {
				var realTitleHTML = realTitle.innerHTML;
				realTitleText = pickUpText(realTitle);
 
				var isPasteable = 0;
				//var containsHTML = /</.test(realTitleHTML);	// contains ANY HTML
				var containsTooMuchHTML = /</.test( realTitleHTML.replace(/<\/?(sub|sup|small|big)>/gi, "") ); // contains HTML that will be ignored when cut-n-pasted as a wikilink
				// calculate whether the title is pasteable
				var verifyTitle = realTitleText.replace(/^ +/, "");		// trim left spaces
				verifyTitle = verifyTitle.charAt(0).toUpperCase() + verifyTitle.substring(1, verifyTitle.length);	// uppercase first character
 
				// if the namespace prefix is there, remove it on our verification copy.  If it isn't there, add it to the original realValue copy.
				if (wgNamespaceNumber != 0) {
					if (wgCanonicalNamespace == verifyTitle.substr(0, wgCanonicalNamespace.length).replace(/ /g, "_") && verifyTitle.charAt(wgCanonicalNamespace.length) == ":") {
						verifyTitle = verifyTitle.substr(wgCanonicalNamespace.length + 1);
					} else {
						realTitleText = wgCanonicalNamespace.replace(/_/g, " ") + ":" + realTitleText;
						realTitleHTML = wgCanonicalNamespace.replace(/_/g, " ") + ":" + realTitleHTML;
					}
				}
 
				// verify whether wgTitle matches
				verifyTitle = verifyTitle.replace(/^ +/, "").replace(/ +$/, "");		// trim left and right spaces
				verifyTitle = verifyTitle.replace(/_/g, " ");		// underscores to spaces
				verifyTitle = verifyTitle.charAt(0).toUpperCase() + verifyTitle.substring(1, verifyTitle.length);	// uppercase first character
				isPasteable = (verifyTitle == wgTitle);
 
				var h1 = document.getElementsByTagName("h1")[0];
				if (h1 && isPasteable) {
					h1.innerHTML = containsTooMuchHTML ? realTitleText : realTitleHTML;
					if (!containsTooMuchHTML)
						realTitleBanner.style.display = "none";
				}
				document.title = realTitleText + " - Second Life Wiki";
			}
		}
	} catch (e) {
		/* Something went wrong. */
	}
    });
}
 
 
// similar to innerHTML, but only returns the text portions of the insides, excludes HTML
function pickUpText(aParentElement) {
  var str = "";
 
  function pickUpTextInternal(aElement) {
    var child = aElement.firstChild;
    while (child) {
      if (child.nodeType == 1)		// ELEMENT_NODE 
        pickUpTextInternal(child);
      else if (child.nodeType == 3)	// TEXT_NODE
        str += child.nodeValue;
 
      child = child.nextSibling;
    }
  }
 
  pickUpTextInternal(aParentElement);
 
  return str;
}

/** Collapsible tables *********************************************************
 *
 *  Description: Allows tables to be collapsed, showing only the header. See
 *			   http://www.mediawiki.org/wiki/Manual:Collapsible_tables.
 *  Maintainers: [[en:User:R. Koot]]
 */
 
var autoCollapse = 2;
var collapseCaption = 'hide';
var expandCaption = 'show';
 
function collapseTable( tableIndex ) {
	var Button = document.getElementById( 'collapseButton' + tableIndex );
	var Table = document.getElementById( 'collapsibleTable' + tableIndex );
 
	if ( !Table || !Button ) {
		return false;
	}
 
	var Rows = Table.rows;
 
	if ( Button.firstChild.data == collapseCaption ) {
		for ( var i = 1; i < Rows.length; i++ ) {
			Rows[i].style.display = 'none';
		}
		Button.firstChild.data = expandCaption;
	} else {
		for ( var i = 1; i < Rows.length; i++ ) {
			Rows[i].style.display = Rows[0].style.display;
		}
		Button.firstChild.data = collapseCaption;
	}
}
 
function createCollapseButtons() {
	var tableIndex = 0;
	var NavigationBoxes = new Object();
	var Tables = document.getElementsByTagName( 'table' );
 
	for ( var i = 0; i < Tables.length; i++ ) {
		if ( hasClass( Tables[i], 'collapsible' ) ) {
 
			/* only add button and increment count if there is a header row to work with */
			var HeaderRow = Tables[i].getElementsByTagName( 'tr' )[0];
			if ( !HeaderRow ) {
				continue;
			}
			var Header = HeaderRow.getElementsByTagName( 'th' )[0];
			if ( !Header ) {
				continue;
			}
 
			NavigationBoxes[tableIndex] = Tables[i];
			Tables[i].setAttribute( 'id', 'collapsibleTable' + tableIndex );
 
			var Button = document.createElement( 'span' );
			var ButtonLink = document.createElement( 'a' );
			var ButtonText = document.createTextNode( collapseCaption );
 
			Button.className = 'collapseButton'; // Styles are declared in [[MediaWiki:Common.css]]
 
			ButtonLink.style.color = Header.style.color;
			ButtonLink.setAttribute( 'id', 'collapseButton' + tableIndex );
			ButtonLink.setAttribute( 'href', '#' );
			addHandler( ButtonLink, 'click', new Function( 'evt', 'collapseTable(' + tableIndex + ' ); return killEvt( evt );' ) );
			ButtonLink.appendChild( ButtonText );
 
			Button.appendChild( document.createTextNode( '[' ) );
			Button.appendChild( ButtonLink );
			Button.appendChild( document.createTextNode( ']' ) );
 
			Header.insertBefore( Button, Header.childNodes[0] );
			tableIndex++;
		}
	}
 
	for ( var i = 0;  i < tableIndex; i++ ) {
		if ( hasClass( NavigationBoxes[i], 'collapsed' ) || ( tableIndex >= autoCollapse && hasClass( NavigationBoxes[i], 'autocollapse' ) ) ) {
			collapseTable( i );
		} else if ( hasClass( NavigationBoxes[i], 'innercollapse' ) ) {
			var element = NavigationBoxes[i];
			while ( element = element.parentNode ) {
				if ( hasClass( element, 'outercollapse' ) ) {
					collapseTable( i );
					break;
				}
			}
		}
	}
}
 
addOnloadHook( createCollapseButtons );
 
/** Test if an element has a certain class **************************************
 *
 * Description: Uses regular expressions and caching for better performance.
 * Maintainers: [[User:Mike Dillon]], [[User:R. Koot]], [[User:SG]]
 */
 
var hasClass = (function() {
	var reCache = {};
	return function( element, className ) {
		return ( reCache[className] ? reCache[className] : ( reCache[className] = new RegExp( "(?:\\s|^)" + className + "(?:\\s|$)" ) ) ).test( element.className );
	};
})();

/* 
 * Added at the request of Strife Onizuka to prevent collapsible tables from jumping to the top of an article when toggled 
 */
function killEvt( evt ) {
	evt = evt || window.event || window.Event; // W3C, IE, Netscape
	if ( typeof ( evt.preventDefault ) != 'undefined' ) {
		evt.preventDefault(); // Don't follow the link
		evt.stopPropagation();
	} else {
		evt.cancelBubble = true; // IE
	}
	return false; // Don't follow the link (IE)
}

/* MediaWiki:Monobook.js */
/* tooltips and access keys */
var ta = new Object();
ta['pt-userpage'] = new Array('.','My user page');
ta['pt-anonuserpage'] = new Array('.','The user page for the ip you\'re editing as');
ta['pt-mytalk'] = new Array('n','My talk page');
ta['pt-anontalk'] = new Array('n','Discussion about edits from this ip address');
ta['pt-preferences'] = new Array('','My preferences');
ta['pt-watchlist'] = new Array('l','The list of pages you\'re monitoring for changes.');
ta['pt-mycontris'] = new Array('y','List of my contributions');
ta['pt-login'] = new Array('o','You are encouraged to log in, it is not mandatory however.');
ta['pt-anonlogin'] = new Array('o','You are encouraged to log in, it is not mandatory however.');
ta['pt-logout'] = new Array('o','Log out');
ta['ca-talk'] = new Array('t','Discussion about the content page');
ta['ca-edit'] = new Array('e','You can edit this page. Please use the preview button before saving.');
ta['ca-addsection'] = new Array('+','Add a comment to this discussion.');
ta['ca-viewsource'] = new Array('e','This page is protected. You can view its source.');
ta['ca-history'] = new Array('h','Past versions of this page.');
ta['ca-protect'] = new Array('=','Protect this page');
ta['ca-delete'] = new Array('d','Delete this page');
ta['ca-undelete'] = new Array('d','Restore the edits done to this page before it was deleted');
ta['ca-move'] = new Array('m','Move this page');
ta['ca-watch'] = new Array('w','Add this page to your watchlist');
ta['ca-unwatch'] = new Array('w','Remove this page from your watchlist');
ta['search'] = new Array('f','Search this wiki');
ta['p-logo'] = new Array('','Main Page');
ta['n-mainpage'] = new Array('z','Visit the Main Page');
ta['n-portal'] = new Array('','About the project, what you can do, where to find things');
ta['n-currentevents'] = new Array('','Find background information on current events');
ta['n-recentchanges'] = new Array('r','The list of recent changes in the wiki.');
ta['n-randompage'] = new Array('x','Load a random page');
ta['n-help'] = new Array('','The place to find out.');
ta['n-sitesupport'] = new Array('','Support us');
ta['t-whatlinkshere'] = new Array('j','List of all wiki pages that link here');
ta['t-recentchangeslinked'] = new Array('k','Recent changes in pages linked from this page');
ta['feed-rss'] = new Array('','RSS feed for this page');
ta['feed-atom'] = new Array('','Atom feed for this page');
ta['t-contributions'] = new Array('','View the list of contributions of this user');
ta['t-emailuser'] = new Array('','Send a mail to this user');
ta['t-upload'] = new Array('u','Upload images or media files');
ta['t-specialpages'] = new Array('q','List of all special pages');
ta['ca-nstab-main'] = new Array('c','View the content page');
ta['ca-nstab-user'] = new Array('c','View the user page');
ta['ca-nstab-media'] = new Array('c','View the media page');
ta['ca-nstab-special'] = new Array('','This is a special page, you can\'t edit the page itself.');
ta['ca-nstab-project'] = new Array('a','View the project page');
ta['ca-nstab-image'] = new Array('c','View the image page');
ta['ca-nstab-mediawiki'] = new Array('c','View the system message');
ta['ca-nstab-template'] = new Array('c','View the template');
ta['ca-nstab-help'] = new Array('c','View the help page');
ta['ca-nstab-category'] = new Array('c','View the category page');

/** "Technical restrictions" title fix *****************************************
 *
 *  Description:
 *  Maintainers: User:Interiot, User:Mets501
 */
 
// For pages that have something like Template:Lowercase, replace the title, but only if it is cut-and-pasteable as a valid wikilink.
//	(for instance iPod's title is updated.  But [[C#]] is not an equivalent wikilink, so [[C Sharp]] doesn't have its main title changed)
//
// The function looks for a banner like this: 
 // <div id="RealTitleBanner">    <!-- div that gets hidden -->
 //   <span id="RealTitle">title</span>
 // </div>
 // An element with id=DisableRealTitle disables the function.
var disableRealTitle = 0;		// users can disable this by making this true from their monobook.js
if (wgIsArticle) {			// don't display the RealTitle when editing, since it is apparently inconsistent (doesn't show when editing sections, doesn't show when not previewing)
    addOnloadHook(function() {
	try {
		var realTitleBanner = document.getElementById("RealTitleBanner");
		if (realTitleBanner && !document.getElementById("DisableRealTitle") && !disableRealTitle) {
			var realTitle = document.getElementById("RealTitle");
			if (realTitle) {
				var realTitleHTML = realTitle.innerHTML;
				realTitleText = pickUpText(realTitle);
 
				var isPasteable = 0;
				//var containsHTML = /</.test(realTitleHTML);	// contains ANY HTML
				var containsTooMuchHTML = /</.test( realTitleHTML.replace(/<\/?(sub|sup|small|big)>/gi, "") ); // contains HTML that will be ignored when cut-n-pasted as a wikilink
				// calculate whether the title is pasteable
				var verifyTitle = realTitleText.replace(/^ +/, "");		// trim left spaces
				verifyTitle = verifyTitle.charAt(0).toUpperCase() + verifyTitle.substring(1, verifyTitle.length);	// uppercase first character
 
				// if the namespace prefix is there, remove it on our verification copy.  If it isn't there, add it to the original realValue copy.
				if (wgNamespaceNumber != 0) {
					if (wgCanonicalNamespace == verifyTitle.substr(0, wgCanonicalNamespace.length).replace(/ /g, "_") && verifyTitle.charAt(wgCanonicalNamespace.length) == ":") {
						verifyTitle = verifyTitle.substr(wgCanonicalNamespace.length + 1);
					} else {
						realTitleText = wgCanonicalNamespace.replace(/_/g, " ") + ":" + realTitleText;
						realTitleHTML = wgCanonicalNamespace.replace(/_/g, " ") + ":" + realTitleHTML;
					}
				}
 
				// verify whether wgTitle matches
				verifyTitle = verifyTitle.replace(/^ +/, "").replace(/ +$/, "");		// trim left and right spaces
				verifyTitle = verifyTitle.replace(/_/g, " ");		// underscores to spaces
				verifyTitle = verifyTitle.charAt(0).toUpperCase() + verifyTitle.substring(1, verifyTitle.length);	// uppercase first character
				isPasteable = (verifyTitle == wgTitle);
 
				var h1 = document.getElementsByTagName("h1")[0];
				if (h1 && isPasteable) {
					h1.innerHTML = containsTooMuchHTML ? realTitleText : realTitleHTML;
					if (!containsTooMuchHTML)
						realTitleBanner.style.display = "none";
				}
				document.title = realTitleText + " - Second Life Wiki";
			}
		}
	} catch (e) {
		/* Something went wrong. */
	}
    });
}
 
 
// similar to innerHTML, but only returns the text portions of the insides, excludes HTML
function pickUpText(aParentElement) {
  var str = "";
 
  function pickUpTextInternal(aElement) {
    var child = aElement.firstChild;
    while (child) {
      if (child.nodeType == 1)		// ELEMENT_NODE 
        pickUpTextInternal(child);
      else if (child.nodeType == 3)	// TEXT_NODE
        str += child.nodeValue;
 
      child = child.nextSibling;
    }
  }
 
  pickUpTextInternal(aParentElement);
 
  return str;
}