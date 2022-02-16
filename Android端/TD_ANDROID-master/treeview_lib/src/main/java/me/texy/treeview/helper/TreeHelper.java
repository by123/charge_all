/*
 * Copyright 2016 - 2017 ShineM (Xinyuan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under.
 */

package me.texy.treeview.helper;

import java.util.ArrayList;
import java.util.List;

import me.texy.treeview.TreeNode;

/**
 * Created by xinyuanzhong on 2017/4/27.
 */

public class TreeHelper {

    public static <T> void expandAll(TreeNode<T> node) {
        if (node == null) {
            return;
        }
        expandNode(node, true);
    }

    /**
     * Expand node and calculate the visible addition nodes.
     *
     * @param treeNode     target node to expand
     * @param includeChild should expand child
     * @return the visible addition nodes
     */
    public static <T> List<TreeNode<T>> expandNode(TreeNode<T> treeNode, boolean includeChild) {
        List<TreeNode<T>> expandChildren = new ArrayList<>();

        if (treeNode == null) {
            return expandChildren;
        }

        treeNode.setExpanded(true);

        if (!treeNode.hasChild()) {
            return expandChildren;
        }

        for (TreeNode<T> child : treeNode.getChildren()) {
            expandChildren.add(child);

            if (includeChild || child.isExpanded()) {
                expandChildren.addAll(expandNode(child, includeChild));
            }
        }

        return expandChildren;
    }

    /**
     * Expand the same deep(level) nodes.
     *
     * @param root  the tree root
     * @param level the level to expand
     */
    public static <T> void expandLevel(TreeNode<T> root, int level) {
        if (root == null) {
            return;
        }

        for (TreeNode<T> child : root.getChildren()) {
            if (child.getLevel() == level) {
                expandNode(child, false);
            } else {
                expandLevel(child, level);
            }
        }
    }

    public static <T> void collapseAll(TreeNode<T> node) {
        if (node == null) {
            return;
        }
        for (TreeNode<T> child : node.getChildren()) {
            performCollapseNode(child, true);
        }
    }

    /**
     * Collapse node and calculate the visible removed nodes.
     *
     * @param node         target node to collapse
     * @param includeChild should collapse child
     * @return the visible addition nodes before remove
     */
    public static <T> List<TreeNode<T>> collapseNode(TreeNode<T> node, boolean includeChild) {
        List<TreeNode<T>> treeNodes = performCollapseNode(node, includeChild);
        node.setExpanded(false);
        return treeNodes;
    }

    private static <T> List<TreeNode<T>> performCollapseNode(TreeNode<T> node, boolean includeChild) {
        List<TreeNode<T>> collapseChildren = new ArrayList<>();

        if (node == null) {
            return collapseChildren;
        }
        if (includeChild) {
            node.setExpanded(false);
        }
        for (TreeNode<T> child : node.getChildren()) {
            collapseChildren.add(child);

            if (child.isExpanded()) {
                collapseChildren.addAll(performCollapseNode(child, includeChild));
            } else if (includeChild) {
                performCollapseNodeInner(child);
            }
        }

        return collapseChildren;
    }

    /**
     * Collapse all children node recursive
     *
     * @param node target node to collapse
     */
    private static <T> void performCollapseNodeInner(TreeNode<T> node) {
        if (node == null) {
            return;
        }
        node.setExpanded(false);
        for (TreeNode<T> child : node.getChildren()) {
            performCollapseNodeInner(child);
        }
    }

    public static <T> void collapseLevel(TreeNode<T> root, int level) {
        if (root == null) {
            return;
        }
        for (TreeNode<T> child : root.getChildren()) {
            if (child.getLevel() == level) {
                collapseNode(child, false);
            } else {
                collapseLevel(child, level);
            }
        }
    }

    public static <T> List<TreeNode<T>> getAllNodes(TreeNode<T> root) {
        List<TreeNode<T>> allNodes = new ArrayList<>();

        fillNodeList(allNodes, root);
        allNodes.remove(root);

        return allNodes;
    }

    private static <T> void fillNodeList(List<TreeNode<T>> treeNodes, TreeNode<T> treeNode) {
        treeNodes.add(treeNode);

        if (treeNode.hasChild()) {
            for (TreeNode<T> child : treeNode.getChildren()) {
                fillNodeList(treeNodes, child);
            }
        }
    }

    /**
     * Select the node and node's children,return the visible nodes
     */
    public static <T> List<TreeNode<T>> selectNodeAndChild(TreeNode<T> treeNode, boolean select) {
        List<TreeNode<T>> expandChildren = new ArrayList<>();

        if (treeNode == null) {
            return expandChildren;
        }

        treeNode.setSelected(select);
        treeNode.setPartialSelected(false);
        if (!treeNode.hasChild()) {
            return expandChildren;
        }

        if (treeNode.isExpanded()) {
            for (TreeNode<T> child : treeNode.getChildren()) {
                expandChildren.add(child);

                if (child.isExpanded()) {
                    expandChildren.addAll(selectNodeAndChild(child, select));
                } else {
                    selectNodeInner(child, select);
                }
            }
        } else {
            selectNodeInner(treeNode, select);
        }
        return expandChildren;
    }

    private static <T> void selectNodeInner(TreeNode<T> treeNode, boolean select) {
        if (treeNode == null) {
            return;
        }
        treeNode.setSelected(select);
        treeNode.setPartialSelected(false);
        if (treeNode.hasChild()) {
            for (TreeNode<T> child : treeNode.getChildren()) {
                selectNodeInner(child, select);
            }
        }
    }

    /**
     * Select parent when all the brothers have been selected, otherwise deselect parent,
     * and check the grand parent recursive.
     */
    public static <T> List<TreeNode<T>> selectParentIfNeedWhenNodeSelected(TreeNode<T> treeNode, boolean select) {
        List<TreeNode<T>> impactedParents = new ArrayList<>();
        if (treeNode == null) {
            return impactedParents;
        }

        //ensure that the node's level is bigger than 1(first level is 1)
        TreeNode<T> parent = treeNode.getParent();
        if (parent == null || parent.getParent() == null) {
            return impactedParents;
        }

        List<TreeNode<T>> brothers = parent.getChildren();
        int selectedBrotherCount = 0;
        for (TreeNode<T> brother : brothers) {
            if (brother.isSelected()) selectedBrotherCount++;
        }

        if (select) {
            if (selectedBrotherCount == brothers.size()) {
                parent.setSelected(true);
                parent.setPartialSelected(false);
                impactedParents.add(parent);
                impactedParents.addAll(selectParentIfNeedWhenNodeSelected(parent, true));
            } else if (selectedBrotherCount <= brothers.size()) {
                parent.setSelected(false);
                parent.setPartialSelected(true);
                impactedParents.add(parent);
                impactedParents.addAll(selectParentIfNeedWhenNodeSelected(parent, true));
            }
        } else if (!select) {
            if (selectedBrotherCount <= brothers.size() - 1 && selectedBrotherCount > 0) {
                //部分选择
                parent.setSelected(false);
                parent.setPartialSelected(true);
                impactedParents.add(parent);
                impactedParents.addAll(selectParentIfNeedWhenNodeSelected(parent, false));

            } else if (selectedBrotherCount == 0) {
                // only the condition that the size of selected's brothers
                // is one less than total count can trigger the deselect
                parent.setSelected(false);
                parent.setPartialSelected(false);
                impactedParents.add(parent);
                impactedParents.addAll(selectParentIfNeedWhenNodeSelected(parent, false));
            }
        }
        return impactedParents;
    }

    /**
     * Get the selected nodes under current node, include itself
     */
    public static <T> List<TreeNode<T>> getSelectedNodes(TreeNode<T> treeNode) {
        List<TreeNode<T>> selectedNodes = new ArrayList<>();
        if (treeNode == null) {
            return selectedNodes;
        }

        if (treeNode.isSelected() && treeNode.getParent() != null) selectedNodes.add(treeNode);

        for (TreeNode<T> child : treeNode.getChildren()) {
            selectedNodes.addAll(getSelectedNodes(child));
        }
        return selectedNodes;
    }


    /**
     * Get the selected nodes under current node, include itself
     * if Parent node is selected ，this chide nodes don't add  the return list
     */
    public static <T> List<TreeNode<T>> getSelectedParentNodes(TreeNode<T> treeNode) {
        List<TreeNode<T>> selectedNodes = new ArrayList<>();
        if (treeNode == null) {
            return selectedNodes;
        }

        if (treeNode.isSelected() && treeNode.getParent() != null) selectedNodes.add(treeNode);

        if (!treeNode.isSelected()) {
            for (TreeNode<T> child : treeNode.getChildren()) {
                selectedNodes.addAll(getSelectedParentNodes(child));
            }
        }
        return selectedNodes;
    }


    /**
     * Return true when the node has one selected child(recurse all children) at least,
     * otherwise return false
     */
    public static <T> boolean hasOneSelectedNodeAtLeast(TreeNode<T> treeNode) {
        if (treeNode == null || treeNode.getChildren().size() == 0) {
            return false;
        }
        List<TreeNode<T>> children = treeNode.getChildren();
        for (TreeNode<T> child : children) {
            if (child.isSelected() || hasOneSelectedNodeAtLeast(child)) {
                return true;
            }
        }
        return false;
    }
}
