<%--

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

--%>

<%@ page import="com.coresecure.brightcove.wrapper.sling.ConfigurationGrabber,
                 com.coresecure.brightcove.wrapper.sling.ConfigurationService,
                 com.coresecure.brightcove.wrapper.sling.ServiceUtil,
                 com.coresecure.brightcove.wrapper.utils.TextUtil,
                 java.util.UUID" %>


<%@include file="/apps/brightcove/components/shared/global.jsp" %>
<%

    String componentID = UUID.randomUUID().toString().replaceAll("-", "");

    String videoID = properties.get("videoPlayer", "").trim();
    String playlistID = properties.get("videoPlayerPL", "").trim();

    String account = properties.get("account", "").trim();
    String playerPath = properties.get("playerPath", "").trim();
    String playerID = "";
    String playerKey = "";

    String playerDataEmbed = "default";

    String containerID = properties.get("containerID", "");
    String containerClass = properties.get("containerClass", "");


    // Default Values

    String align = "center";
    String width = "";
    String height = "";
    boolean hasSize = false;

    // Load Player Configuration

    if (!playerPath.isEmpty()) {

        Resource playerPageResource = resourceResolver.resolve(playerPath);

        if (playerPageResource != null) {

            Page playerPage = playerPageResource.adaptTo(Page.class);

            if (playerPage != null) {

                ValueMap playerProperties = playerPage.getProperties();

                playerID = playerProperties.get("playerID", playerID);
                playerKey = playerProperties.get("playerKey", playerKey);
                playerDataEmbed = playerProperties.get("data_embedded", playerDataEmbed);


                align = playerProperties.get("align", align);
                width = playerProperties.get("width", width);
                height = playerProperties.get("height", height);

                //append the class to the container wrap
                containerClass += " " + playerProperties.get("containerClass", "");
            }

        }

    }

    // Override with local component properties

    align = properties.get("align", align);


    //we must override BOTH width and height to prevent one being set on Player Page and other set in component.
    if (properties.containsKey("width") || properties.containsKey("height")) {
        width = properties.get("width", width);
        height = properties.get("height", height);
    }

    // Adjust size accordingly
    if (TextUtil.notEmpty(width) || TextUtil.notEmpty(height)) {
        hasSize = true;
        if (TextUtil.isEmpty(width)) {
            width = String.valueOf((480 * Integer.parseInt(height, 10)) / 270);
        } else if (TextUtil.isEmpty(height)) {
            height = String.valueOf((270 * Integer.parseInt(width, 10)) / 480);
        }
    }

    //fallback to default
    if (TextUtil.isEmpty(playerID) && TextUtil.notEmpty(account)) {
        ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
        ConfigurationService cs = cg.getConfigurationService(account);
        if (cs != null) {
            playerID = cs.getDefVideoPlayerID();
            playerDataEmbed = cs.getDefVideoPlayerDataEmbedded();
        }
    }


    // Update Page Context
    pageContext.setAttribute("brc_account", account, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_videoID", videoID, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_playlistID", playlistID, PageContext.REQUEST_SCOPE);

    pageContext.setAttribute("brc_playerPath", playerPath, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_playerID", playerID, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_playerKey", playerKey, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_playerDataEmbed", playerDataEmbed, PageContext.REQUEST_SCOPE);

    pageContext.setAttribute("brc_align", align, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_width", width, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_height", height, PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("brc_hasSize", hasSize, PageContext.REQUEST_SCOPE);


    pageContext.setAttribute("brc_componentID", componentID, PageContext.REQUEST_SCOPE);

    //Component Container
    pageContext.setAttribute("brc_containerID", containerID);
    pageContext.setAttribute("brc_containerClass", containerClass);

%>