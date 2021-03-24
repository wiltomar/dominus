import { Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, BeforeInsert, BeforeUpdate, BaseEntity } from 'typeorm';

class Base extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  uuid: string;

  @CreateDateColumn()
  createdat: Date;

  @UpdateDateColumn()
  updatedat: Date;

  @Column()
  deletedat: Date;
  
  @Column()
  status: boolean;
  
  @BeforeInsert()
  setCreatedat(): void {
    this.createdat = new Date();
    this.status = true;
  }

  @BeforeUpdate()
  setUpdatedat(): void {
    this.updatedat = new Date();
  }
}

export default Base;