/*


 Adobe CQ5 Brightcove Connector

 Copyright (C) 2015 Coresecure Inc.

 Authors:    Alessandro Bonfatti
 Yan Kisen

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.



 */
{
    "tabTip": CQ.I18n.getMessage("Brightcove Playlist"),
    "id": "cfTab-BrightcoveP",
    "iconCls": "cq-cft-tab-icon brightcove_p",
    "xtype": "contentfindertab",
    "ranking": 30,
    "allowedPaths": [
                     "/content/*",
                     "/etc/scaffolding/*",
                     "/etc/workflow/packages/*"
                 ],
    "items": [
       CQ.wcm.ContentFinderTab.getQueryBoxConfig({
            "id": "cfTab-BrightcovePL-QueryBox",
            "items": [
                CQ.wcm.ContentFinderTab.getSuggestFieldConfig({"url":  CQ.shared.HTTP.getContextPath() +"/bin/brightcove/suggestions.json?type=playlist"}),
                {
                        xtype: "spacer",
                        height: 5
                },
                {
                    xtype: "combo",
                    id: "cfTab-BrightcovePL-account",
                    name:"account_id",
                    triggerAction:"all",
                    store: {
                        "url": CQ.shared.HTTP.getContextPath() +'/bin/brightcove/accounts.json',
                        "reader": new CQ.Ext.data.JsonReader({
                            "root": "accounts",
                            "fields": [
                                "text", "value"
                            ]                            
                        })
                    },
                	valueField: 'value',  
   					displayField: 'text',  
                    editable: false,
                    emptyText: CQ.I18n.getMessage("Filter by account"),
                	style:"",
                	listeners: {
                    	select: function (combo, record, index ) {
                    		var store = CQ.Ext.getCmp("cfTab-BrightcoveP").items.get(0);
                    		var contentfinder_element = CQ.Ext.getCmp("cfTab-BrightcoveP");
                    		contentfinder_element.submitQueryBox(store);
                    	}
                    }
                }
            ]
        }),
        CQ.wcm.ContentFinderTab.getResultsBoxConfig({
            "itemsDDGroups": ["brightcove_playlist"],
            "itemsDDNewParagraph": {
                "path": "brightcove/components/content/brightcoveplaylist",
                "propertyName": "./videoPlayerPL"
            },
            "noRefreshButton": true,
            "items": {
                "tpl":
                    '<tpl for=".">' +
                            '<div class="cq-cft-search-item" title="{thumbnailURL}" ondblclick="window.location= CQ.shared.HTTP.getContextPath() +\'/brightcove/admin\';">' +
                                    '<div class="cq-cft-search-thumb-top"' +
                                    ' style="background-image:url(\'/etc/designs/cs/brightcove/shared/img/noThumbnailPL.png\');"></div>' +
                                         '<div class="cq-cft-search-text-wrapper">' +
                                            '<div class="cq-cft-search-title"><p class="cq-cft-search-title">{name}</p><p>{path}</p></div>' +
                                        '</div>' +
                                    '<div class="cq-cft-search-separator"></div>' +
                            '</div>' +
                    '</tpl>',
                "itemSelector": CQ.wcm.ContentFinderTab.DETAILS_ITEMSELECTOR
            },
            
            "tbar": [
                CQ.wcm.ContentFinderTab.REFRESH_BUTTON, "->",
                {
                    text: "Export CSV",
                    handler: function() {
                        var url= CQ.shared.HTTP.getContextPath() +'/bin/brightcove/api?a=6';  
                        window.open(url, 'Download');

                   }
                }
            ]
        },{
            "url": "/bin/brightcove/api?a=4"
        },{
            "autoLoad":false,
            "reader": new CQ.Ext.data.JsonReader({
                "root": "items",
                "fields": [
                    {name:"name"},
                    {name:"path", mapping:"id"},
                    {name:"thumbnailURL", type:"string", mapping:"thumbnailURL"}
                ],
                "id": "path"
                
            })
        
        })
    ]

}