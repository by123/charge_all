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

package me.texy.treeview.base;

import java.util.List;

import me.texy.treeview.TreeNode;

/**
 * Created by xinyuanzhong on 2017/4/20.
 */

public interface BaseTreeAction<T> {
    void expandAll();

    void expandNode(TreeNode<T> treeNode);

    void expandLevel(int level);

    void collapseAll();

    void collapseNode(TreeNode<T> treeNode);

    void collapseLevel(int level);

    void toggleNode(TreeNode<T> treeNode);

    void deleteNode(TreeNode<T> node);

    void addNode(TreeNode<T> parent, TreeNode<T> treeNode);

    void addNodes(TreeNode<T> parent, List<TreeNode<T>> treeNode);

    List<TreeNode<T>> getAllNodes();

    // TODO: 17/4/30
    // 1.add node at position
    // 2.add slide delete or other operations

}
