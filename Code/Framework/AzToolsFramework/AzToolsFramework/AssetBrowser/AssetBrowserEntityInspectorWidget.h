/*
 * Copyright (c) Contributors to the Open 3D Engine Project.
 * For complete copyright and license terms please see the LICENSE at the root of this distribution.
 *
 * SPDX-License-Identifier: Apache-2.0 OR MIT
 *
 */
#pragma once

#if !defined(Q_MOC_RUN)
#include <AzCore/std/containers/set.h>
#include <AzToolsFramework/AssetBrowser/AssetBrowserBus.h>
#include <AzToolsFramework/AssetBrowser/Entries/ProductAssetBrowserEntry.h>
#include <AzToolsFramework/AssetBrowser/Entries/SourceAssetBrowserEntry.h>
#include <AzToolsFramework/AssetDatabase/AssetDatabaseConnection.h>
#include <AzQtComponents/Components/Widgets/Card.h>
#include <QFormLayout>
#include <QLabel>
#include <QStackedLayout>
#include <QTreeWidget>
#endif

namespace AzToolsFramework
{
    namespace AssetBrowser
    {
        class PreviewerFrame;

        class AssetBrowserEntityInspectorWidget
            : public QWidget
            , public AssetBrowserPreviewRequestBus::Handler
        {
        public:
            explicit AssetBrowserEntityInspectorWidget(QWidget *parent = nullptr);
            ~AssetBrowserEntityInspectorWidget();

            void InitializeDatabase();

            //////////////////////////////////////////////////////////////////////////
            // AssetBrowserPreviewRequestBus
            //////////////////////////////////////////////////////////////////////////
            void PreviewAsset(const AzToolsFramework::AssetBrowser::AssetBrowserEntry* selectedEntry) override;
            void ClearPreview() override;
        private:
            // Query the direct and reverse source dependencies of a source asset browser entry
            void PopulateSourceDependencies(
                const SourceAssetBrowserEntry* sourceEntry, AZStd::vector<const ProductAssetBrowserEntry*> productList);
            // Query the direct and reverse product depdencies of a product asset browser entry
            bool PopulateProductDependencies(const ProductAssetBrowserEntry* productEntry);
            // Create an incoming or outgoing dependecy QTreeWidgetItem for each valid Uuid
            void CreateSourceDependencyTree(const AZStd::set<AZ::Uuid> sourceUuids, bool isOutgoing);
            // Create an incoming or outgoing dependency QTreeWidgetItem for each valid AssetId
            void CreateProductDependencyTree(const AZStd::set<AZ::Data::AssetId> dependencyUuids, bool isOutgoing);
            // Adds the name and icon of an asset browser entry under a QTreeWidgetItem
            void AddAssetBrowserEntryToTree(const AssetBrowserEntry* entry, QTreeWidgetItem* headerItem);

            AZStd::shared_ptr<AssetDatabase::AssetDatabaseConnection> m_databaseConnection;
            bool m_databaseReady = false;

            QStackedLayout* m_layoutSwitcher = nullptr;
            QWidget* m_emptyLayoutWidget = nullptr;
            QWidget* m_populatedLayoutWidget = nullptr;

            QLabel* m_previewImage = nullptr;

            QWidget* m_assetDetailWidget = nullptr;
            QFormLayout* m_assetDetailLayout = nullptr;

            AzQtComponents::Card* m_dependentAssetsCard = nullptr;
            QTreeWidget* m_dependentProducts = nullptr;

            QFont m_headerFont;
        };

    } // namespace AssetBrowser
} // namespace AzToolsFramework

