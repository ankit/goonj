/*
	File: GXSPFPlaylist.m
	Description: XSPF playlist support (implementation).

	This file is part of Goonj.

	Goonj is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Goonj is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Goonj. If not, see <http://www.gnu.org/licenses/>.

    Copyright 2009 Pratul Kalia.
	Copyright 2009 Ankur Sethi.
*/

#import "GXSPFPlaylist.h"


@implementation GXSPFPlaylist

- (GPlaylist *) initWithFile:(NSString *)aURL
{
    if (self = [super init])
        return self;

    return nil;
}

- (GPlaylistType) playlistType
{
    return kXSPFType;
}

- (BOOL) savePlaylistAs:(NSString *)aURL
{
    // TODO: save more metadara.

	// Set up the namespace.
	NSXMLNode *XSPFNamespace = [[NSXMLNode alloc] initWithKind:NSXMLNamespaceKind];
	[XSPFNamespace setName:@""];
	[XSPFNamespace setStringValue:@"http://xspf.org/ns/0/"];

	// Why do I have to create a separate NSXMLNode for every single
	// attribute? Meh.
	NSXMLNode *XSPFVersion = [[NSXMLNode alloc] initWithKind:NSXMLAttributeKind];
	[XSPFVersion setName:@"version"];
	[XSPFVersion setStringValue:@"1.0"];

	// Create root element.
	NSXMLElement *XSPFRoot = [[NSXMLElement alloc] initWithName:@"playlist"];
	[XSPFRoot addNamespace:XSPFNamespace];
	[XSPFRoot addAttribute:XSPFVersion];

	// Create the actual document.
	NSXMLDocument *XSPFDoc = [[NSXMLDocument alloc] initWithRootElement:XSPFRoot];
	[XSPFDoc setVersion:@"1.0"];
	[XSPFDoc setCharacterEncoding:@"UTF-8"];

	NSXMLElement *XSPFTrackList = [[NSXMLElement alloc] initWithName:@"trackList"];
	[XSPFRoot addChild:XSPFTrackList];

	NSXMLElement *XSPFTrack;
	NSXMLElement *XSPFLocation;

	// It might be a good idea to check if the playlist is being saved in the
	// same directory as the music files. If yes, then we can use relative
	// paths instead of absolute paths.
	for (GTrack *track in tracks) {
		XSPFTrack = [[NSXMLElement alloc] initWithName:@"track"];
		[XSPFTrackList addChild:XSPFTrack];

		XSPFLocation = [[NSXMLElement alloc] initWithName:@"location"];
		[XSPFLocation setStringValue:[[track path] absoluteString]];
		[XSPFTrack addChild:XSPFLocation];
	}

	// Write data to file. TODO: replace existing file when saving.
	NSData *XMLData = [XSPFDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
	return [XMLData writeToFile:aURL atomically:NO];
}

- (BOOL) loadPlaylist:(NSString *)aURL
{
}

@end