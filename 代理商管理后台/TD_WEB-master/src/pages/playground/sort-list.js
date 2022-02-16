import React from 'react';

import SortableList, { arrayMove } from '../../components/SortableList';

export default class SortList extends React.Component {
  state = {
    items: [
      'Gold',
      'Crimson',
      'Blueviolet',
      'Cornflowerblue',
    ],
  }
  handleSortEnd = ({ oldIndex, newIndex }) => {
    this.setState({
      items: arrayMove(this.state.items, oldIndex, newIndex),
    });
  };
  render() {
    return (<div>
      <h1>拖拽移动组件</h1>
      <SortableList items={this.state.items} onSortEnd={this.handleSortEnd} />
    </div>);
  }
}
